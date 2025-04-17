#import "@preview/fletcher:0.5.6" as fletcher: diagram, node, edge
#import fletcher.shapes: pill, hexagon

#let election_pipeline = {
  let tan = color.hsl(45deg, 22%, 96%)
  diagram(
    node-stroke: 1pt,
    node-inset: 10pt,
    label-size: 11pt,
    label-sep: 0.5em,
    spacing: 4em,
    label-wrapper: edge => box(
      [#edge.label],
      inset: .4em,
      radius: .2em,
      fill: luma(90%),
    ),

    node(enclose: ((-0.6,-0.6), (0.6,+2.2)), inset: 10pt, stroke: tan, fill: tan),
    node(enclose:((-0.6, -0.6), (0.6, -0.5)), [For each voting block $i$], stroke: luma(60%), fill: tan),
    // voting bloc
   	node((0,0), [Preference $cal(P)_(i)(V_i, theta_i)$], shape: pill),
   	edge("-|>", [Sample $m_i$ times from \ preference model $cal(P)_(i)(V_i, theta_i)$], label-side: center),
   	node((0,1), [Honest profile $Pi_i$]),
   	edge("-|>", [Sample $cal(S)_i$ and apply the tactic], label-side: center),
   	node((0,2), [Strategic profile $cal(S)_(i)(Pi_i)$], shape: pill),
   	// method
   	edge("-|>", [Aggregate all $Pi_i$], label-side: center),
    edge((0.5, 2), (0, 3), "-|>"),
    edge((-0.5, 2), (0, 3), "-|>"),
   	node((0,3), [Aggregate profile $Pi$]),
   	edge([Tabulate with method $cal(M)$], "-|>", label-side: center),
   	node((0,4), [Outcome], shape: hexagon, extrude: (-3, 0)),
  )
}

#set page(width: auto, height: auto)
#election_pipeline
