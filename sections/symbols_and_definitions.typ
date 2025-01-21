= Symbols and Definitions <symbols-definitions>

#set table(
  columns: 2,
  stroke: (_, y) => {
    if y == 0 { (bottom: 1pt + black) } else { (top: 0.5pt + black) }
  },
  row-gutter: 0.2em,
)
#figure(
  table(
    table.header([*Symbol*], [*Definition*],),
    [$A, B, C, ...$], [Candidates],
    [$a, b, c, ...$], [Voters],
    [${a, b, c, ...}$], [The set of all voters],
    [...], [The preference of a voter $x$],
    [...], [The ballot of a voter $x$],
    [$prec, succ, prec.eq, succ.eq$], [$A prec B$ $=>$ $A$ is preferred to $B$, \ $A prec.eq B$ $=>$ $A$ is preferred or indifferent to $B$],
    [$cal(W)(x)$], [Social welfare function for a voter $x$],
    [$cal(I)(h, ...)$], [A ballot generator (synthesizer) with some hyper-parameters $h$],
    [$cal(S)(x)$], [The strategy for a voter $x$],
    [$cal(M)({a, b, c, ...})$], [The outcome of a method, $M$, on a set of ballots.],
  )
) <symbols>
