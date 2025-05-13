= Symbols and Definitions <ch:symbols-definitions>

#figure(caption: [Symbols and Definitions])[
  #table(
    columns: 2,
    table.header([*Symbol*], [*Definition*],),
    [$C = {c_i | i in {1..n}}$], [A set of candidates],
    [$V = {v_i | i in {1..n}}$], [A set of voters],
    [$Pi = {pi_i | i in {1..n}}$], [A set of ballots (a profile)],
    [$prec, succ, prec.not, succ.not$ \ $prec.eq, succ.eq, prec.eq.not, succ.eq.not$], [$pi_i prec pi_j => pi_i "is preferred to" pi_j$, \ $pi_i prec.eq pi_i => pi_i "is preferred or indifferent to" pi_j$],
    [$cal(W)(v_i)$], [The social welfare function for voter $i$],
    [$cal(P)(v_i, theta)$], [The preferences of voter $i$ given hyperparameters $theta$],
    [$cal(S)(v_i)$], [The strategy for voter $i$],
    [$cal(M)(Pi)$], [The outcome of a method $M$ on a set of ballots $Pi$.],
  )
] <symbols>
