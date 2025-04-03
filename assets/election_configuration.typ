#import "@preview/fletcher:0.5.6" as fletcher: diagram, node, edge
#import fletcher.shapes: pill, hexagon, rect

#let election_configuration = {
  diagram(
    node-stroke: 1pt,
    node-inset: 10pt,

    node((0, 0), [Election], name: <election>, shape: rect),
    node((-0.8, 1), [$C$], name: <candidates>, shape: rect),
    node((0, 1), [$V$], name: <voters>, shape: rect),
    node((0.8, 1), [$cal(M)$], name: <method>, shape: rect),
    node((-0.4, 2), [$cal(P)$], name: <preferences>, shape: rect),
    node((0.4, 2), [$cal(S)$], name: <strategy>, shape: rect),

    edge(<candidates>, "u", <election>, marks: "-n"),
    edge(<voters>, <election>, marks: "-n!"),
    edge(<method>, "u", <election>, marks: "-1"),
    edge(<preferences>, (0, 1.5), <voters>, "-1", ),
    edge(<strategy>, (0, 1.5), <voters>, "-1"),

  )
}

#set page(width: auto, height: auto)
#election_configuration
