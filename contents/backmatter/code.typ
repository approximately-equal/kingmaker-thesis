= Code Appendix

All simulations were run using `kingmaker`, a modular, performant, social choice framework for the simulation, computation, and analysis of strategic voting. `kingmaker` is publicly available at #link("https://github.com/Approximately-Equal/kingmaker")[Approximately-Equal/kingmaker], dual licensed under the MIT and Apache 2.0 licenses.

Below, there the code used to generate @fig:across-cohesion. The code to generate @fig:across-tactics, @fig:across-method-A, @fig:across-method-B, and @fig:across-method-C are similar, but left out for brevity. They are all publicly available at #link("https://github.com/Approximately-Equal/kingmaker-findings")[Approximately-Equal/kingmaker-findings]

==  Code for @fig:across-cohesion (Across Cohesion)

#figure(caption: [Rust code for @fig:across-cohesion])[
  #raw(read("../../assets/code/across_cohesion.rs"), lang: "Rust", block: true)
]
#figure(caption: [R code for @fig:across-cohesion])[
  #raw(read("../../assets/code/across_cohesion.R"), lang: "R", block: true)
]
