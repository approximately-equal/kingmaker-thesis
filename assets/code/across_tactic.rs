use kingmaker::prelude::*;

fn build_election(
    dispersion: f64,
    weight: f32,
    tactic_1: impl Tactic<Ordinal> + 'static,
    tactic_2: impl Tactic<Ordinal> + 'static,
) -> Election<Ordinal, methods::IRV> {
    let candidate_pool = vec![
        Candidate::new(0, "A", Some("DEM"), None),
        Candidate::new(1, "B", Some("REP"), None),
        Candidate::new(2, "C", Some("GREEN"), None),
        Candidate::new(3, "D", None, None),
    ];
    let voting_blocks = vec![
        VotingBloc::builder(
            preferences::Mallows::new(vec![0, 2, 3, 1], dispersion),
            5_000,
        )
        .add_tactic(tactic_1, weight)
        .add_tactic(tactics::Identity, 1.0 - weight)
        .build(),
        VotingBloc::builder(
            preferences::Mallows::new(vec![1, 2, 3, 0], 1.0 - dispersion),
            5_000,
        )
        .add_tactic(tactic_2, weight)
        .add_tactic(tactics::Identity, 1.0 - weight)
        .build(),
    ];
    Election::new(candidate_pool, voting_blocks, methods::IRV)
}

fn main() {
    let mut configurations = vec![];
    let tactics = ["identity", "compromise", "burial", "pushover"];
    for tactic_1 in tactics {
        for tactic_2 in tactics {
            for i in 40..=60 {
                let dispersion = (1.0 / 100.0) * i as f64;
                let weight = 0.1;
                let election = match tactic_1 {
                    "identity" => match tactic_2 {
                        "identity" => {
                            build_election(dispersion, weight, tactics::Identity, tactics::Identity)
                        }
                        "compromise" => build_election(
                            dispersion,
                            weight,
                            tactics::Identity,
                            tactics::Compromise(vec![1]),
                        ),
                        "burial" => build_election(
                            dispersion,
                            weight,
                            tactics::Identity,
                            tactics::Burial(vec![0]),
                        ),
                        "pushover" => build_election(
                            dispersion,
                            weight,
                            tactics::Identity,
                            tactics::Pushover {
                                preferred: vec![1],
                                pushover: vec![2, 3],
                            },
                        ),
                        _ => panic!("Invalid method"),
                    },
                    "compromise" => match tactic_2 {
                        "identity" => build_election(
                            dispersion,
                            weight,
                            tactics::Compromise(vec![0]),
                            tactics::Identity,
                        ),
                        "compromise" => build_election(
                            dispersion,
                            weight,
                            tactics::Compromise(vec![0]),
                            tactics::Compromise(vec![1]),
                        ),
                        "burial" => build_election(
                            dispersion,
                            weight,
                            tactics::Compromise(vec![0]),
                            tactics::Burial(vec![0]),
                        ),
                        "pushover" => build_election(
                            dispersion,
                            weight,
                            tactics::Compromise(vec![0]),
                            tactics::Pushover {
                                preferred: vec![1],
                                pushover: vec![2, 3],
                            },
                        ),
                        _ => panic!("Invalid method"),
                    },
                    "burial" => match tactic_2 {
                        "identity" => build_election(
                            dispersion,
                            weight,
                            tactics::Burial(vec![1]),
                            tactics::Identity,
                        ),
                        "compromise" => build_election(
                            dispersion,
                            weight,
                            tactics::Burial(vec![1]),
                            tactics::Compromise(vec![1]),
                        ),
                        "burial" => build_election(
                            dispersion,
                            weight,
                            tactics::Burial(vec![1]),
                            tactics::Burial(vec![0]),
                        ),
                        "pushover" => build_election(
                            dispersion,
                            weight,
                            tactics::Burial(vec![1]),
                            tactics::Pushover {
                                preferred: vec![1],
                                pushover: vec![2, 3],
                            },
                        ),
                        _ => panic!("Invalid method"),
                    },
                    "pushover" => match tactic_2 {
                        "identity" => build_election(
                            dispersion,
                            weight,
                            tactics::Pushover {
                                preferred: vec![0],
                                pushover: vec![2, 3],
                            },
                            tactics::Identity,
                        ),
                        "compromise" => build_election(
                            dispersion,
                            weight,
                            tactics::Pushover {
                                preferred: vec![0],
                                pushover: vec![2, 3],
                            },
                            tactics::Compromise(vec![1]),
                        ),
                        "burial" => build_election(
                            dispersion,
                            weight,
                            tactics::Pushover {
                                preferred: vec![0],
                                pushover: vec![2, 3],
                            },
                            tactics::Burial(vec![0]),
                        ),
                        "pushover" => build_election(
                            dispersion,
                            weight,
                            tactics::Pushover {
                                preferred: vec![0],
                                pushover: vec![2, 3],
                            },
                            tactics::Pushover {
                                preferred: vec![1],
                                pushover: vec![2, 3],
                            },
                        ),
                        _ => panic!("Invalid method"),
                    },
                    _ => panic!("Invalid method"),
                };
                let outcomes = election.run_many(1000, 0);
                let line = format!(
                    "dispersion = {}, weight = {}, tactic_1 = {}, tactic_2 = {}",
                    dispersion, weight, tactic_1, tactic_2
                );
                let dash_count = 80usize.saturating_sub(line.len());
                println!("{}{}", line, "-".repeat(dash_count));
                println!("{:?}", election.display(&outcomes));
                let json = serde_json::json!({
                    "tactic_1": tactic_1,
                    "tactic_2": tactic_2,
                    "dispersion": dispersion,
                    "weight": weight,
                    "outcomes": election.outcomes(outcomes)
                });
                configurations.push(json);
            }
        }
    }
    for config in configurations {
        println!("{},", config);
    }
}
