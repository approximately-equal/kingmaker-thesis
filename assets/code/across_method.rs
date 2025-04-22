use kingmaker::prelude::*;

fn build_election<M: Method<Ballot = Ordinal>>(
    dispersion_1: f64,
    dispersion_2: f64,
    weight: f32,
    tactic_1: &str,
    tactic_2: &str,
    method: M,
) -> Election<Ordinal, M> {
    let candidate_pool = vec![
        Candidate::new(0, "A", Some("DEM"), None),
        Candidate::new(1, "B", Some("REP"), None),
        Candidate::new(2, "C", Some("GREEN"), None),
        Candidate::new(3, "D", None, None),
    ];
    let dem_voting_block = match tactic_1 {
        "identity" => VotingBloc::builder(
            preferences::Mallows::new(vec![0, 2, 3, 1], dispersion_1),
            4_500,
        )
        .add_tactic(tactics::Identity, weight)
        .add_tactic(tactics::Identity, 1.0 - weight)
        .build(),
        "compromise" => VotingBloc::builder(
            preferences::Mallows::new(vec![0, 2, 3, 1], dispersion_1),
            4_500,
        )
        .add_tactic(tactics::Compromise(vec![0]), weight)
        .add_tactic(tactics::Identity, 1.0 - weight)
        .build(),
        "burial" => VotingBloc::builder(
            preferences::Mallows::new(vec![0, 2, 3, 1], dispersion_1),
            4_500,
        )
        .add_tactic(tactics::Burial(vec![1]), weight)
        .add_tactic(tactics::Identity, 1.0 - weight)
        .build(),
        "pushover" => VotingBloc::builder(
            preferences::Mallows::new(vec![0, 2, 3, 1], dispersion_1),
            4_500,
        )
        .add_tactic(
            tactics::Pushover {
                preferred: vec![0],
                pushover: vec![2, 3],
            },
            weight,
        )
        .add_tactic(tactics::Identity, 1.0 - weight)
        .build(),
        _ => panic!("Invalid tactic"),
    };
    let rep_voting_block = match tactic_2 {
        "identity" => VotingBloc::builder(
            preferences::Mallows::new(vec![1, 2, 3, 0], dispersion_2),
            4_500,
        )
        .add_tactic(tactics::Identity, weight)
        .add_tactic(tactics::Identity, 1.0 - weight)
        .build(),
        "compromise" => VotingBloc::builder(
            preferences::Mallows::new(vec![1, 2, 3, 0], dispersion_2),
            4_500,
        )
        .add_tactic(tactics::Compromise(vec![1]), weight)
        .add_tactic(tactics::Identity, 1.0 - weight)
        .build(),
        "burial" => VotingBloc::builder(
            preferences::Mallows::new(vec![1, 2, 3, 0], dispersion_2),
            4_500,
        )
        .add_tactic(tactics::Burial(vec![0]), weight)
        .add_tactic(tactics::Identity, 1.0 - weight)
        .build(),
        "pushover" => VotingBloc::builder(
            preferences::Mallows::new(vec![1, 2, 3, 0], dispersion_2),
            4_500,
        )
        .add_tactic(
            tactics::Pushover {
                preferred: vec![1],
                pushover: vec![2, 3],
            },
            weight,
        )
        .add_tactic(tactics::Identity, 1.0 - weight)
        .build(),
        _ => panic!("Invalid tactic"),
    };
    let ind_voting_block =
        VotingBloc::builder(preferences::Mallows::new(vec![3, 2, 0, 1], 0.2), 1000)
            .add_tactic(tactics::Identity, 1.0)
            .build();
    let voting_blocks = vec![dem_voting_block, rep_voting_block, ind_voting_block];
    Election::new(candidate_pool, voting_blocks, method)
}

fn build_election_batch<M: Method<Ballot = Ordinal> + serde::Serialize + Clone>(
    method: M,
) -> Vec<serde_json::Value> {
    let mut configurations = vec![];
    let tactics = ["identity", "compromise", "burial", "pushover"];
    for disp_1 in [40, 45, 50, 55, 60] {
        for disp_2 in [40, 45, 50, 55, 60] {
            let disp_1 = (1.0 / 100.0) * disp_1 as f64;
            let disp_2 = (1.0 / 100.0) * disp_2 as f64;
            let weight = 0.1;
            for i in 0..tactics.len() {
                for j in i..tactics.len() {
                    let tactic_1 = tactics[i];
                    let tactic_2 = tactics[j];
                    let election =
                        build_election(disp_1, disp_2, weight, tactic_1, tactic_2, method.clone());
                    let outcomes = election.run_many(1_000, 3);
                    let json = serde_json::json!({
                        "dispersion_1": disp_1,
                        "dispersion_2": disp_2,
                        "weight": weight,
                        "tactic_1": tactic_1,
                        "tactic_2": tactic_2,
                        "method": method,
                        "outcomes": election.outcomes(outcomes)
                    });
                    configurations.push(json);

                    // display
                    let line = format!(
                        "d_1 = {}, d_2 = {}, weight = {}, tactic_1 = {}, tactic_2 = {}, method = {:?}",
                        disp_1, disp_2, weight, tactic_1, tactic_2, method
                    );
                    println!("{}", line);
                }
            }
        }
    }
    configurations
}

fn main() {
    let random_dictator = build_election_batch(methods::RandomDictator);
    for config in random_dictator {
        println!("{},", config);
    }
}
