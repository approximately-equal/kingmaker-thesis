#import "../../assets/assest.typ": election_pipeline, election_configuration

= Methods <methods>

#stack(
  dir: ltr,
  figure(caption: [Overview of the election pipeline])[
    #election_pipeline
  ],
  h(1fr),
  stack(
    dir: ttb,
    figure(caption: [Structure of an election configuration])[
      #election_configuration
    ],
    // v(3em),
    // figure(caption: [Content of election configuration])[]
  )
) #v(1em)

- #highlight[state diagram + pipeline diagram]
- #highlight[Give a general overview of the pipeline and state]
- #highlight[Add and then relax constraint on the definitions of preference and ballot]
- #highlight[Add which implementations there are for each: preferences, tactics, methods]

== Candidates

Before the election can begin, candidates must be registered. This is done by creating a `Candidate` struct and adding it to the `CandidatePool`. A candidate is as follows:

```rust
pub struct Candidate {
    id: Id,
    name: String,
    party: Option<String>,
    positions: Option<Vec<NotNan<f32>>>,
}
```

and a `CandidatePool` is simply a vector of `Candidate`:

```rust
pub struct CandidatePool(pub Vec<Candidate>);
```

The `CandidatePool` is used to store and manage all registered candidates in the election. It provides methods for adding, removing, and retrieving candidates.

You might be confused about the addition of the `positions` field to the `Candidate` struct. This is ignored in most cases, but we'll talk about when and where it will be used later on.

== Preferences & Realization

Preferences within kingmaker correspond roughly with preferences as described in theory, but mean something distinct in practice. Preferences are defined in the following manner:

```rust
pub trait Preference<B: Ballot>: Send + Sync + Debug {
    fn draw(&self, candidate_pool: &CandidatePool, rng: &mut StdRng) -> B;
    fn sample(
        &self,
        candidate_pool: &CandidatePool,
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

== Tactics & Strategies

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

where `Arc<dyn Tactic<B>>` is a tactic and `f32` is the likelihood of the voter choosing that tactic.

== Voters & Voting Blocks

#highlight[Talk about the voting block struct and its implications on the model of voting and its limitations]

== Methods & Outcomes

With the profile of ballots in hand, the final step is to tabulate the results and determine the outcome. For this we use whichever `Method` we defined when configuring the election. An election is defined:

```rust
pub trait Method: Send + Sync {
    type Ballot: Ballot;
    type Winner: Outcome;
    fn outcome(
        &self,
        candidate_pool: &CandidatePool,
        profile: &Profile<Self::Ballot>,
    ) -> Self::Winner;
}
```

and functions precisely as the theory would dictate. It takes a profile and candidate pool and determines the winner(s). Note that the outcomes could be a `SingleWinner` or a `MultiWinner` depending on whether the office is single-member or multi-member.

== Elections

```rust
pub struct Election<B, C, M>
where
    B: Ballot,
    C: Send + Sync,
    M: Method<Ballot = B>,
{
    candidate_pool: CandidatePool,
    voter_pool: VoterPool<B, C>,
    method: M,
}
```
