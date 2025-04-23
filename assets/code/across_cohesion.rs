use kingmaker::prelude::*;

fn build_election(
    dispersion: f64,
    weight: f32,
    tactic: impl Tactic<Ordinal> + 'static,
) -> Election<(), Ordinal, methods::IRV> {
    let candidate_pool = vec![
        Candidate::new(0, "A", Some("DEM"), None),
        Candidate::new(1, "B", Some("REP"), None),
        Candidate::new(2, "C", None, None),
    ];
    let voting_blocs = vec![
        VotingBloc::builder(
            preferences::Mallows::new(vec![0, 2, 1], dispersion),
            5_000,
        )
        .add_tactic(tactic, weight)
        .add_tactic(tactics::Identity, 1.0 - weight)
        .build(),
        VotingBloc::builder(
            preferences::Mallows::new(vec![1, 2, 0], 1.0 - dispersion),
            5_000,
        )
        .add_tactic(tactics::Identity, 1.0)
        .build(),
    ];
    Election::new((), candidate_pool, voting_blocs, methods::IRV)
}

fn main() {
    let mut configurations = vec![];
    for i in 0..=100 {
        for tactic in ["identity", "compromise", "burial", "pushover"] {
            let dispersion = (1.0 / 100.0) * i as f64;
            let weight = 0.1;
            let election = match tactic {
                "identity" => build_election(
                    dispersion,
                    weight,
                    tactics::Identity,
                ),
                "compromise" => build_election(
                    dispersion,
                    weight,
                    tactics::Compromise(vec![0]),
                ),
                "burial" => build_election(
                    dispersion,
                    weight,
                    tactics::Burial(vec![1]),
                ),
                "pushover" => build_election(
                    dispersion,
                    weight,
                    tactics::Pushover {
                        preferred: vec![0],
                        pushover: vec![1],
                    },
                ),
                _ => panic!("Invalid method"),
            };
            let outcomes = election.run_many(1000, 0);
            let line = format!(
                "dispersion = {}, weight = {} tactic = {}",
                dispersion, weight, tactic
            );
            let dash_count = 80usize.saturating_sub(line.len());
            println!("{}{}", line, "-".repeat(dash_count));
            println!("{:?}", election.display(&outcomes));
            let json = serde_json::json!({
                "tactic": tactic,
                "dispersion": dispersion,
                "weight": weight,
                "outcomes": election.outcomes(outcomes)
            });
            configurations.push(json);
        }
    }
    for config in configurations {
        println!("{},", config);
    }
}
