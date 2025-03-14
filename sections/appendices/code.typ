= Code Appendix <code>

```rust
use kingmaker::prelude::*;

fn main() {
    // define candidates
    let candidate_pool = CandidatePool::new(vec![
        Candidate::new(0, "A", Some("DEM"), Default::default()),
        Candidate::new(1, "B", Some("REP"), Default::default()),
        Candidate::new(2, "C", None, Default::default()),
    ]);
    // define voting blocks
    let voter_pool = VoterPool::new(
        (),
        vec![VotingBlock::<Ordinal>::new(
            preferences::Impartial::new(),
            Strategy::new().add_tactic(tactics::Identity, 1.0),
            1_000,
        )],
    );
    // define election
    let election = Election::new(
        candidate_pool,
        voter_pool,
        methods::Plurality,
    );
    // run election(s)
    let outcomes = election.run_many(1_000, 0);
    // display outcome
    println!("{}", election.write(outcomes));
}
``` <minimal-example>

And the code is available at #link("https://github.com/Approximately-Equal/Kingmaker")[Approximately-Equal/Kingmaker]
