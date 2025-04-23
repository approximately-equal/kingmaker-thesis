= Code Appendix <code>

All simulations were run using `kingmaker`, a modular, performant, social choice framework for the simulation, computation, and analysis of strategic voting. `kingmaker` is publicly available at #link("https://github.com/Approximately-Equal/kingmaker")[Approximately-Equal/kingmaker], dual licensed under the MIT and Apache 2.0 licenses.

Below, there the code used to generate @across-cohesion. The code to generate @across-tactic, @across-method-A, @across-method-B, and @across-method-C are similar, but left out for brevity. They are all publicly available at #link("https://github.com/Approximately-Equal/kingmaker-findings")[Approximately-Equal/kingmaker-findings]

==  Code for @across-cohesion (Across Cohesion)

#figure(caption: [Rust code for @across-cohesion])[
  #raw(read("../../assets/code/across_cohesion.rs"), lang: "Rust", block: true)
]
#figure(caption: [R code for @across-cohesion])[
  #raw(read("../../assets/code/across_cohesion.R"), lang: "R", block: true)
]

// == Code for @across-tactic (Across Tactic)

// #figure(caption: [Rust code for @across-tactic])[
//   #raw(read("../../assets/code/across_tactic.rs"), lang: "Rust", bloc: true)
// ]
// #figure(caption: [R code for @across-tactic])[
//   #raw(read("../../assets/code/across_tactic.R"), lang: "R", bloc: true)
// ]

// == Code for @across-method-A, @across-method-B, @across-method-C (Across Method)

// #figure(caption: [Rust code for @across-method-A, @across-method-B, @across-method-C])[
//   #raw(read("../../assets/code/across_method.rs"), lang: "Rust", bloc: true)
// ]
// #figure(caption: [R code for @across-method-A, @across-method-B, @across-method-C])[
//   #raw(read("../../assets/code/across_method.R"), lang: "R", bloc: true)
// ]
