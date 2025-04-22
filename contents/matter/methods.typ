#import "../../assets/assets.typ": election_pipeline, election_configuration
#import "../../template/utilities.typ": description-list

= Methods <methods>

#stack(
  dir: ltr,
  box(width: 50%)[
    #figure(caption: [Overview of the election pipeline.])[
      #election_pipeline <election-pipeline>
    ]
  ],
  stack(
    dir: ttb,
    box(width: 50%)[
      #figure(caption: [Structure of an election configuration.])[
        #election_configuration <election_configuration>
      ]
      _KEY_: An election consists of candidates $C$, voting blocks $B$, and election method $cal(M)$. A voting block $i$ consists of preferences $cal(P_i)$ and a strategy $cal(S_i)$
    ]
  )
)

In `kingmaker`, realization, strategy-application, aggregation, and tabulation have well-defined behavior, which we will explore in-depth shortly. The above diagrams give a high-level overview of the pipeline and configuration of the election process and the particular way that `kingmaker` implements it. It is important to understand that this model is _not_ realistic and has limitations that will be discussed thoroughly.

== Candidates <candidate>

In a real election, candidates must be registered before voting can begin. Similarly, in `kingmaker` an election must be configured with some set of candidates. This is done by creating a `Candidate` structure. A candidate is defined as follows:

#figure(caption: [Candidate implementation in `kingmaker`])[
  ```rust
  /// A candidate in an election.
  #[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Serialize)]
  pub struct Candidate {
      /// Unique identifier for the candidate
      id: Id,
      /// The name of the candidate
      name: String,
      /// The party the candidate is associated with, if any
      party: Option<String>,
      /// The (spacial) positions the candidate holds, if any
      positions: Option<Vec<NotNan<f32>>>,
  }
  ```
]

One may be confused about the addition of the `positions` field to the `Candidate` structure. This is ignored in most cases, but in spacial voting it represents the policy positions of the candidate in some abstract "policy space".

== Preferences & Realization <preference>

Preferences within `kingmaker` correspond with preferences as described in @realization, as some distribution over possible ballots. They are defined in the following manner:

#figure(caption: [Preference implementation in `kingmaker`])[
  ```rust
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

While preferences may be implemented the same as @realization, the way they are _utilized_ in `kingmaker` is different. In theory---and reality---preferences are defined per voter. In `kingmaker` preferences are defined once for a bloc of voters (e.g. Democrats, Independents, etc). This means that when different voters draw from the preference, they are drawing from the same underlying distribution. Thus we should model preferences for a voting bloc as aggregate preferences of all voters in the voting bloc, and that each draw is that voters individual preferences being defined.

This notion is not entirely accurate, as this means that realization is a fixed effect that depends entirely on the average preferences of the voting bloc that they are a member of. In reality, preferences can vary within a voting bloc, and individual preferences may deviate from the average in a random way. In this way, aggregating all preferences within a voting bloc loses valuable information. However, it is sufficient for our purposes.

We are primarily interested in well-known and well-understood preference models, thus `kingmaker` implements a number of such preference models. These include:

#figure(caption: [List of preferences currently implemented in `kingmaker`])[
  #description-list(
    table.header([*Preference*], [*Description*],),
    [`Impartial`], [Select a ballot uniformly at random.],
    [`Manual`], [Select a ballot based on user input.],
    [`PlackettLuce`], [Select a ballot based on a Plackett-Luce distribution.],
    [`Mallows`], [Select a ballot based on a Mallows distribution.],
    // [Spacial], [Select a ballot based on a spatial distribution.],
  )
] <preferences-table>

== Tactics & Strategies <strategy>

Tactics in `kingmaker` correspond exactly with tactics as defines by theory, as deterministic processes that voters can engage with to increase their social welfare. Tactics are defined in the following manner:

#figure(caption: [Tactic implementation in `kingmaker`])[
  ```rust
  /// A tactic is a method of altering one's ballot to maximize (or at least increase) social welfare.
  ///
  /// Note that this implementation considers tactics to be a separate process that occurs *after* realization. This is a limitation of the model.
  pub trait Tactic<B: Ballot>: Send + Sync + Debug {
      /// Applies the tactic to the given ballot.
      fn apply(&self, ballot: B) -> B;
  }
  ```
]

Strategies, on the other hand, are a statistical extension that allows for stochastic strategic thinking. Strategies are defined as distributions over tactics, and are defined with ```rust Vec<(Arc<dyn Tactic<B>>, f32)>```. Breaking this down, ```rust Vec``` is just a list, and each list item contains a tactic (```rust Arc<dyn Tactic<B>>```), and a likelihood of the voter choosing that tactic (```rust f32```).

Again, `kingmaker` implements a number of well-known tactics. These include:

#figure(caption: [List of tactics currently implemented in `kingmaker`])[
  #description-list(
    table.header([*Tactic*], [*Description*],),
    [`Identity`], [Default to the voter's original preference.],
    [`Random`], [Select a re-ordering uniformly at random.],
    [`Compromise`], [Place candidates with a higher likelihood of being elected first, over more preferred candidates.],
    [`Burial`], [Place candidates with a higher likelihood of being elected last, over less preferred candidates.],
    [`Pushover`], [Place pushover candidates higher in the ranking, not to increase the likelihood of winning, but to eliminate stronger more preferred candidates early in tabulation rounds to then be defeated later by more preferred candidates.]
  )
] <tactics-table>

== Voters & Voting Blocs <voting-bloc>

In real-world elections, voters rarely act in complete isolation. Instead, shared interests, identities, or affiliations often lead individuals to vote in coordinated ways. These voting blocs—groups of voters with similar preferences or strategies—can form around political parties, regional identities, demographic categories, or shared ideologies. Their collective behavior can significantly shape electoral outcomes, amplify certain voices, and even enable strategic voting on a larger scale.

They are also a useful tool from the perspective of campaigns, as they can target specific voting blocs with tailored messages and strategies to influence their preferences and voting behavior. `kingmaker` also implements voting blocs, and in fact voters are entirely represented by voting blocs internally.

Voting blocs are defined as follows:

#figure(caption: [Voting bloc implementation in `kingmaker`])[
  ```rust
  /// A bloc of voters is considered to have a single aggregate preference and set of tactics. They represent the sum total distribution across all the voters in the bloc. When a voter draws from this distribution, that is the expression of their preferences / individuality.
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

While this abstraction enables efficient simulation and experimentation, it also introduces several important limitations that distance the model from real-world complexity.

First, _each voter is a member of exactly one voting bloc_. In reality, individuals may belong to overlapping social, cultural, and political groups, each influencing their preferences to varying degrees. This one-to-one assignment flattens the multidimensional nature of voter identity and suppresses potential interactions between intersecting group affiliations.

Second, _each voting bloc has a single aggregate preference and strategy, shared by all of its members_. While this simplifies the sampling of preferences and strategies during simulation, it eliminates within-bloc heterogeneity. In reality, even tightly aligned groups exhibit variation in how strongly they hold certain views or how likely they are to support specific candidates. A more realistic might model voters with mixed-effects models, where membership to a particular voting bloc is a fixed effect, and individual voter preferences are a random effect. This applies both to preferences and strategies.

== Methods & Outcomes <methods>

With the profile of ballots in hand, the final step is to tabulate the results and determine the outcome. For this we use whichever `Method` we defined when configuring the election. An election is defined precisely the same as the theory suggests. It takes a pool of candidates and a profile of ballots and tabulates an outcome. It's a pure function with no side effects. Note that the outcomes could be a `SingleWinner` or a `MultiWinner` depending on whether the office is single-member or multi-member.

#figure(caption: [Method implementation in `kingmaker`])[
  ```rust
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
  #description-list(
    table.header([*Method*], [*Description*],),
    [`RndDictator`], [Randomly select a voter and then select their top choice.],
    [`Plurality`], [Select the candidate with the most (plurality of) first-place votes.],
    [`Approval`], [Select the candidate with the most approval votes.],
    [`Borda`], [For a given ballot, the first place candidate receives `n` points, the second place candidate receives `n-1` points, and so on, where `n` is the number of candidates. The candidate with the highest total score wins.],
    [`IRV`], [Eliminating the candidate with the fewest first-place votes until a candidate has a majority of first-place votes.],
    [`STV`], [Select $n$ candidates by eliminating the candidate with the fewest first-place, transferring votes from candidates who get elected, and redistributing votes until $n$ candidates have a majority of first-place votes.],
    [`STAR`], [...]
  )
] <methods-table>

== Elections <election>

#figure(caption: [Election implementation in `kingmaker`])[
  ```rust
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

The `Election` simply aggregates the necessary information: `conditions`, `candidate_pool`, `voter_pool`, and `method`, and provides a convenient interface for running elections. There are two methods for running elections: ```rust election.run_once(seed: u64)``` and ```rust election.run_many(times: usize, seed: u64)```. There are also the ```rust display``` and ```rust write``` functions, which output the election results to stdout or write them to a configuration file, respectively, after the simulation has completed.
