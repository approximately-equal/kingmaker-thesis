// #let description-list(inner) = {
//   set table(
//     columns: 2,
//     stroke: (_, y) => {
//       if y == 0 { (bottom: 1pt + black) } else { (top: 0.5pt + black) }
//     },
//     row-gutter: 0.2em,
//   )
//   table(inner)
// }

#let description-list = table.with(
  columns: 2,
  stroke: (_, y) => {
    (bottom: 0.5pt + black)
    if y == 0 { (bottom: 1pt + black) }
    if y == 1 { (top: 0.5pt + black) }
  },
  row-gutter: 0.2em,
)
