#import "../../assets/assets.typ": election_pipeline, election_configuration

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
      _KEY_: An election consists of candidates $C$, voting blocks $B$, and election method $cal(M)$. A voting block consists of preferences $cal(P)$ and a strategy $cal(S)$
    ]
  )
) #v(1em)

In kingmaker, ballot generation, aggregation, and tabulation has a well-defined behavior, which we will explore in-depth shortly. The above diagrams give a high-level overview of the pipeline and state. As you can see, ballots begin as preferences, are realized into ballots, are converted _independently_ into strategic ballots, and then aggregated into a profile. This profile is then tabulated via the voting method, and a winner is determined. Its important to understand that this process is _not_ necessarily realistic and has limitations that will be discussed in detail.

== Candidates <candidate>

Before the election can begin, candidates must be registered. This is done by creating a `Candidate` struct. A candidate is as follows:

```rust
pub struct Candidate {
    id: Id,
    name: String,
    party: Option<String>,
    positions: Option<Vec<NotNan<f32>>>,
}
```

You might be confused about the addition of the `positions` field to the `Candidate` struct. This is ignored in most cases, but we'll talk about when and where it will be used later on.

== Preferences & Realization <preference>

Preferences within kingmaker correspond roughly with preferences as described in theory, but mean something distinct in practice. Preferences are defined in the following manner:

```rust
pub trait Preference<B: Ballot>: Send + Sync + Debug {
    fn draw(&self, candidate_pool: &CandidatePool, rng: &mut StdRng) -> B;
    fn sample(
        &self,
        candidate_pool: &[Candidate],
        sample_size: usize,
        rng: &mut StdRng,
    ) -> Vec<B> {
        (0..sample_size)
            .map(|_| self.draw(candidate_pool, rng))
            .collect()
    }
}
```

On its surface this is precisely equal to its theoretical counterpart: bound by the ballot type and set of candidates, preference is some distribution that can be drawn from to produce a ballot. However note the `sample` method. This hints to the larger distinction.

The difference is that preferences are not defined on a voter by voter basis, but instead are defined for a block of voters (e.g. Democrats, Independents, etc). This means that when different voters draw from the preference, they are drawing from the same underlying distribution. Thus we should model preferences as aggregate preferences of all voters in the voting block, and that each draw is that voters individual preferences being defined. Although this notion is not entirely accurate, since grouping all voter preferences together loses information. However it is sufficient for our purposes.

We are primarily interested in well-known and well-understood preferences, so `kingmaker` implements a number of well-known preferences. These include:

- `Impartial`: Select a preference uniformly at random.
- `Manual`: Select a preference based on user input.
- `PlackettLuce`: Select a preference based on a Plackett-Luce distribution.
- `Mallows`: Select a preference based on a Mallows distribution.
// - `Spacial`: Select a preference based on a spatial distribution.

== Tactics & Strategies <strategy>

Tactics in kingmaker correspond exactly with tactics as defines by theory, as deterministic processes that voters can engage with to increase their social welfare. Tactics are defined in the following manner:

```rust
pub trait Tactic<B: Ballot>: Send + Sync + Debug {
    fn apply(&self, ballot: B) -> B;
}
```

Strategies, on the other hand, are a statistical extension that allows for stochastic strategic thinking. Strategies are defined as distributions over tactics, and are defined:

```rust
pub struct Strategy<B: Ballot> {
    tactics: Vec<(Arc<dyn Tactic<B>>, f32)>,
}
```

where `Arc<dyn Tactic<B>>` is a `Tactic` and `f32` is the likelihood of the voter choosing that tactic.

Again, `kingmaker` implements a number of well-known tactics. These include:

- `Identity`: Default to the voter's original preference.
- `Random`: Select a re-ordering uniformly at random.
- `Compromise`: Place candidates with a higher likelihood of being elected first, over more preferred candidates.
- `Burial`: Place candidates with a higher likelihood of being elected last, over less preferred candidates.
- `Pushover`: Place pushover candidates higher in the ranking, not to increase the likelihood of winning, but to eliminate stronger more preferred candidates early in tabulation rounds to then be defeated later by more preferred candidates.

== Voters & Voting Blocks <voting-block>

A voting block is defined:

```rust
pub struct VotingBlock<B: Ballot> {
    members: usize,
    preference: Arc<dyn Preference<B>>,
    strategy: Strategy<B>,
}
```

which is to say, a group of voters who share a common preference and strategy for voting.

Voting blocks are centrally important to understanding the trade-offs and limitations of `kingmaker`. They allow us to model the behavior of voters and their preferences, but only in certain ways. Like we mentioned earlier, preference aggregation and the difference between group and individual preferences exist because of voting blocks and constructed to have one aggregate preference. The same aggregation applies to strategy, where we aggregate the strategies of each voter in the block to determine the overall strategy of the block.

== Methods & Outcomes <methods>

With the profile of ballots in hand, the final step is to tabulate the results and determine the outcome. For this we use whichever `Method` we defined when configuring the election. An election is defined:

```rust
pub trait Method: Send + Sync {
    type Ballot: Ballot;
    type Winner: Outcome;
    fn outcome(
        &self,
        candidate_pool: &[Candidate],
        profile: &Profile<Self::Ballot>,
    ) -> Self::Winner;
}
```

and functions precisely as the theory would dictate. It takes a profile and candidate pool and determines the winner(s). Note that the outcomes could be a `SingleWinner` or a `MultiWinner` depending on whether the office is single-member or multi-member.

`kingmaker` implements a number of well-known methods, as well as a few novel ones. These include:

- `RandomDictator`: Select the winner by randomly selecting a voter and then selecting their top choice.
- `Plurality` / `First Past the Post`: Select a winner by selecting the candidate with the most first-place votes.
- `Approval`: Select a winner by selecting the candidate with the most approval votes.
- `Borda`: For a given ballot, the first place candidate receives `n` points, the second place candidate receives `n-1` points, and so on, where `n` is the number of candidates. The candidate with the highest total score wins.
- `InstantRunoff`: Select a winner by eliminating the candidate with the fewest first-place votes until a candidate has a majority of first-place votes.
- `SingleTransferableVote`: Select $n$ candidates by eliminating the candidate with the fewest first-place, transferring votes from candidates who get elected, and redistributing votes until $n$ candidates have a majority of first-place votes.
- `Star`: ...

== Elections <election>

```rust
pub struct Election<B, C, M>
where
    B: Ballot,
    C: Send + Sync,
    M: Method<Ballot = B>,
{
    conditions: C,
    candidate_pool: Vec<Candidate>,
    voter_pool: Vec<VotingBlock<B>>,
    method: M,
}
```

The `Election` simply aggregates the necessary information `conditions`, `candidate_pool`, `voter_pool`, and `method`, and provides a convenient interface for running elections. There are two methods for running elections: ```rust election.run_once(seed: u64)``` and ```rust election.run_many(times: usize, seed: u64)```. There are also useful helper functions for displaying election results.
