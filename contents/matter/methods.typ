#import "../../assets/assets.typ": election_pipeline, election_configuration

= Methods <chp:methods>

In this chapter, I describe each component of `kingmaker`, my framework for simulating strategic elections. In `kingmaker` an election is composed of a few core parts: a set of candidates, a set of voting blocs, and a method. A voting bloc has a preference and a strategy. The structure of an election is shown in @election-configuration. `kingmaker` also sets an election pipeline (see @election-pipeline) that specifies how ballots are generated, and how elections are tabulated and decided. It is important to understand that this model is _not_ realistic and has limitations that will be discussed thoroughly.

#stack(
  dir: ltr,
  box(width: 50%)[
    #figure(caption: [Overview of the election pipeline.])[
      #election_pipeline
    ] <election-pipeline>
  ],
  stack(
    dir: ttb,
    box(width: 50%)[
      #figure(caption: [Structure of an election configuration.])[
        #election_configuration
      ] <election-configuration>
      _KEY_: An election consists of candidates $C$, voting blocs $B$, and election method $cal(M)$. A voting bloc $i$ consists of preferences $cal(P_i)$ and a strategy $cal(S_i)$
    ]
  )
)

== Candidate

In a real election, candidates must be registered before voting can begin. Similarly, in `kingmaker` an election must be configured with some set of candidates. This is done by creating a `Candidate` structure. A candidate is defined as follows:

#figure(caption: [Candidate implementation in `kingmaker`])[
  ```Rust
  /// A candidate in an election.
  #[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Serialize)]
  pub struct Candidate {
      /// Unique identifier for the candidate
      id: Id,
      /// The name of the candidate
      name: String,
      /// The party the candidate is associated with, if any
      party: Option<String>,
      /// The (spatial) positions the candidate holds, if any
      positions: Option<Vec<NotNan<f32>>>,
  }
  ```
]

One may be confused about the addition of the `positions` field to the `Candidate` structure. This is ignored in most cases, but in spatial voting it represents the policy positions of the candidate in some abstract "policy space".

== Preferences & Realization

Preferences within `kingmaker` correspond with preferences as described in @sct:realization, as some distribution over possible ballots. They are defined in the following manner:

#figure(caption: [Preference implementation in `kingmaker`])[
  ```Rust
  /// A preference can be conceptualized as the preferences of the voter as they exist in their head before being written down.
  ///
  /// It is defined as a distribution over possible realizations (ballots), where at election time, one such realization is drawn.
  pub trait Preference<B: Ballot>: Send + Sync + Debug {
      /// Draws a ballot from the preference distribution.
      fn draw(
          &self,
          candidate_pool: &[Candidate],
          rng: &mut StdRng
      ) -> B;
      /// Samples a profile from the preference distribution.
      fn sample(
          &self,
          candidate_pool: &[Candidate],
          sample_size: usize,
          rng: &mut StdRng,
      ) -> Profile<B> {
          // create profile by drawing from the preference
          // distribution `sample_size` times
          Profile::new((0..sample_size)
              .map(|_| self.draw(candidate_pool, rng)))
      }
  }
  ```
]

While preferences may be implemented the same as @sct:realization, the way they are _utilized_ in `kingmaker` is different. In theory---and reality---preferences are defined per voter. In `kingmaker`, preferences are defined once for a bloc of voters (e.g., Democrats, Independents, etc). This means that when different voters draw from the preference, they are drawing from the same underlying distribution. Thus we should model preferences for a voting bloc as aggregate preferences of all voters in the voting bloc, and that each draw is that voter's individual preferences being defined.

This notion is not entirely accurate, as this means that realization depends entirely on the average preferences of the voting bloc that they are a member of, with no intra-bloc differentiation. In reality, preferences can vary within a voting bloc, and individual preferences may deviate from the average in a random way. In this way, aggregating all preferences within a voting bloc loses valuable information. However, it is sufficient for our purposes.

We are primarily interested in well-known and well-understood preference models, thus `kingmaker` implements a number of such preference models. These include:

#figure(caption: [List of preferences currently implemented in `kingmaker`])[
  #table(
    columns: 2,
    table.header([*Preference*], [*Description*],),
    [`Impartial`], [Select a ballot uniformly at random.],
    [`Manual`], [Select a ballot based on user input.],
    [`PlackettLuce`], [Select a ballot based on a Plackett-Luce distribution.],
    [`Mallows`], [Select a ballot based on a Mallows distribution.],
    // [Spacial], [Select a ballot based on a spatial distribution.],
  )
]

== Tactics & Strategies

Tactics in `kingmaker` correspond exactly with tactics as defined by theory: deterministic processes that voters can engage with to increase their social welfare. Tactics are defined in the following manner.

#figure(caption: [Tactic implementation in `kingmaker`])[
  ```Rust
  /// A tactic is a method of altering one's ballot to maximize (or at least increase) social welfare.
  ///
  /// Note that this implementation considers tactics to be a separate process that occurs *after* realization. This is a limitation of the model.
  pub trait Tactic<B: Ballot>: Send + Sync + Debug {
      /// Applies the tactic to the given ballot.
      fn apply(&self, ballot: B) -> B;
  }
  ```
]

Strategies, on the other hand, are a statistical extension that allows for stochastic strategic thinking. Strategies are defined as distributions over tactics, and are defined with ```Rust Vec<(Arc<dyn Tactic<B>>, f32)>```. Breaking this down, ```Rust Vec``` is just a list, and each list item contains a tactic (```Rust Arc<dyn Tactic<B>>```), and a likelihood of the voter choosing that tactic (```Rust f32```).

Again, `kingmaker` implements a number of well-known tactics. These include:

#figure(caption: [List of tactics currently implemented in `kingmaker`])[
  #table(
    columns: 2,
    table.header([*Tactic*], [*Description*],),
    [`Identity`], [Default to the voter's original preference.],
    [`Random`], [Select a re-ordering uniformly at random.],
    [`Compromise`], [Place candidates with a higher likelihood of being elected first, over more preferred candidates.],
    [`Burial`], [Place candidates with a higher likelihood of being elected last, over less preferred candidates.],
    [`Pushover`], [Place pushover candidates higher in the ranking, not to increase the likelihood of winning, but to eliminate stronger more preferred candidates early in tabulation rounds to then be defeated later by more preferred candidates.]
  )
]

== Voters & Voting Blocs

In real-world elections, voters rarely act in complete isolation. Instead, shared interests, identities, or affiliations often lead individuals to vote in coordinated ways. These voting blocs—groups of voters with similar preferences or strategies—can form around political parties, regional identities, demographic categories, or shared ideologies. Their collective behavior can significantly shape electoral outcomes, amplify certain voices, and even enable strategic voting on a larger scale.

They are also a useful tool from the perspective of campaigns, as they can target specific voting blocs with tailored messages and strategies to influence their preferences and voting behavior. `kingmaker` also implements voting blocs, and in fact voters are entirely represented by voting blocs internally.

Voting blocs are defined as follows:

#figure(caption: [Voting bloc implementation in `kingmaker`])[
  ```Rust
  /// A bloc of voters with a preference and a strategy
  #[derive(Debug)]
  pub struct VotingBloc<B: Ballot> {
      /// The preference of the voting bloc
      preference: Arc<dyn Preference<B>>,
      /// The strategy of the voting bloc
      strategy: Vec<(Arc<dyn Tactic<B>>, f32)>,
      /// The number of members in the voting bloc
      members: usize,
  }
  ```
]

Notice how a bloc of voters is considered to have a single aggregate preference and set of tactics. They represent the sum total distribution across all the voters in the bloc. When a voter draws from this distribution, that is the expression of their preferences / individuality.

While this abstraction enables efficient simulation and experimentation, it also introduces several important limitations that distance the model from real-world complexity.

First, _each voter is a member of exactly one voting bloc_. In reality, individuals may belong to overlapping social, cultural, and political groups, each influencing their preferences to varying degrees. This one-to-one assignment flattens the multidimensional nature of voter identity and suppresses potential interactions between intersecting group affiliations.

Second, _each voting bloc has a single aggregate preference and strategy, shared by all of its members_. While this simplifies the sampling of preferences and strategies during simulation, it eliminates within-bloc heterogeneity at the preference level (but there is heterogeneity at the ballot level because each voter randomly realizes a ballot). In reality, even tightly aligned groups exhibit variation in how strongly they hold certain views or how likely they are to support specific candidates. A more realistic model might consider voters as having their own preferences, which are modified by the voting blocs that they are members of. This makes voting blocs function as some preference mode, but allows individuals to have their own preferences or strategies. It also allows for voters to be part of multiple voting blocs, which better models real voters, who are members of various social groups that holistically influence their preferences. Note that this applies to strategies as well as preferences.

== Methods & Outcomes

With the profile of ballots in hand, the final step is to tabulate the results and determine the outcome. For this we use whichever `Method` we defined when configuring the election. An election is defined precisely the same as the theory suggests. It takes a pool of candidates and a profile of ballots and tabulates an outcome. It's a pure function with no side effects. Note that the outcomes could be a `SingleWinner` or a `MultiWinner` depending on whether the office is single-member or multi-member.

#figure(caption: [Method implementation in `kingmaker`])[
  ```Rust
  /// A method of tabulating votes and determining the winner of an election.
  ///
  /// A method is defined to be a set of rules (an algorithm) that determines the outcome of an election.
  ///
  /// From a social choice perspective, a method is a social welfare function that ranks potential outcomes by desirability by aggregating collective preferences (a profile).
  pub trait Method: Send + Sync {
      type Ballot: Ballot;
      type Winner: Outcome;
      /// Determines the outcome of an election.
      fn outcome(
          &self,
          candidate_pool: &[Candidate],
          profile: Profile<Self::Ballot>,
      ) -> Self::Winner;
  }
  ```
]

Kingmaker implements a number of well-known methods, as well as a few novel ones. These include:

#figure(caption: [List of methods currently implemented in `kingmaker`])[
  #table(
    columns: 2,
    table.header([*Method*], [*Description*],),
    [`RndDictator`], [Randomly select a voter and then select their top choice.],
    [`Plurality`], [Select the candidate with the most (plurality of) first-place votes.],
    [`Approval`], [Select the candidate with the most approval votes.],
    [`Borda`], [For a given ballot, the first place candidate receives `n` points, the second place candidate receives `n-1` points, and so on, where `n` is the number of candidates. The candidate with the highest total score wins.],
    [`IRV`], [Eliminating the candidate with the fewest first-place votes until a candidate has a majority of first-place votes.],
    [`STV`], [Select $n$ candidates by eliminating the candidate with the fewest first-place, transferring votes from candidates who get elected, and redistributing votes until $n$ candidates have a majority of first-place votes.],
    [`STAR`], [Standing for "score then automatic runoff", there are two rounds of scoring. In the first round, the total scores given to each candidate are tallied, and the top 2 candidates move to the second round. In the second round, count the times each of the two candidates is preferred to the other. Whichever candidate is the more preferred wins.]
  )
]

== Elections

The `Election` simply aggregates the necessary information: `conditions`, `candidate_pool`, `voter_pool`, and `method`, and provides a convenient interface for running elections. There are two methods for running elections: ```Rust election.run_once(seed: u64)``` and ```Rust election.run_many(times: usize, seed: u64)```. There are also the ```Rust display``` and ```Rust write``` functions, which output the election results to stdout or write them to a configuration file, respectively, after the simulation has completed.


#figure(caption: [Election implementation in `kingmaker`])[
  ```Rust
  /// An election is a simulation of the voting process. It is constructed with a set of conditions, a set of candidates, a pool of voters, and a method for determining the winner.
  #[derive(Debug)]
  pub struct Election<B, C, M>
  where
      B: Ballot,
      C: Send + Sync, // shared info about social conditions
      M: Method<Ballot = B>,
  {
      conditions: C,
      candidates: Vec<Candidate>,
      voter_pool: Vec<VotingBloc<B>>,
      method: M,
  }
  ```
]
