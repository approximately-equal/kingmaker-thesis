// imports =====================================================================

#import "frontmatter.typ": title-page, signature-page, frontmatter
#import "packages/theorion.typ": *
#import "packages/zebraw.typ": *
#import "pagebreaks.typ": *

// thesis ======================================================================

#let thesis(
  title: [Thesis Title],
  author: "Student",
  advisors: ("Advisor",),
  date: datetime.today(),
  college: [Reed College],
  program: (
    division: [Mathematical and Natural Sciences],
    major: [Mathematics - Statistics]
  ),
  frontmatter: [],
  matter: [],
  backmatter: [],
  bibliography: none,
) = (body) => {
  // metadata --
  set document(title: title, author: author, date: date)

  // text --
  set text(font: ("Libertinus Serif",), size: 12pt, weight: 400)
  set par(
    justify: true, leading: 0.7em, spacing: 0.7em, first-line-indent: 1.5em,
  )
  show link: underline
  show link: set text(style: "oblique")

  // headings (general) --
  set heading(numbering: "1.")
  show heading: set text(style: "italic", weight: "regular")
  show heading: set block(above: 2em, below: 1em)

  // headings (per level)
  show heading.where(level: 1): it => {
    sectionbreak()
    it
  }
  show heading.where(level: 1): set text(30pt)
  show heading.where(level: 2): set text(20pt)
  show heading.where(level: 3): set text(16pt)

  // page setup (headers, footers, layout) --
  set page(
    paper: "us-letter",
    margin: (inside: 1.5in, outside: 1.0in, top: 1.5in, bottom: 1.0in),
    footer: [],
  )

  // footnotes --
  set footnote.entry(indent: 0em, separator: line(length: 25%, stroke: 0.75pt), gap: 0.65em)
  show footnote.entry: set text(7.25pt)

  // mathematics --
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 1.5em)

  // figures & tables --
  show figure.where(kind: image): set figure(placement: auto)
  show figure.where(kind: raw).or(figure.where(kind: table)): f => [#v(1em) #f #v(1em)]
  show figure: set block(breakable: true)
  show figure.where(kind: figure): set figure(supplement: [Fig])
  show figure.where(kind: table): set figure(supplement: [Table])
  show figure.where(kind: raw): set figure(supplement: [Code])
  show figure.where(kind: table): set align(left)
  show figure.where(kind: raw): set align(left)
  set table(
    stroke: (_, y) => {
      (bottom: 0.5pt + black)
      if y == 0 { (bottom: 1pt + black) }
      if y == 1 { (top: 0.5pt + black) }
    },
    row-gutter: 0.2em,
  )

  // captions --
  show figure.caption: set align(left)
  show figure.caption: emph

  // lists & enums --
  show enum: set block(spacing: 1.5em)
  show list: set block(above: 1.5em)

  // raw text & code --
  show raw: set text(font: "Maple Mono", weight: "regular", size: 9pt)

  // packages --
  show: show-theorion
  show: zebraw.with(indentation: 4)

  // title & signature pages --
  title-page(title, author, date, program)
  signature-page(advisors, program)

  // frontmatter --
  frontmatter

  // matter --
  set page(
    numbering: "1.1",
    header: context{ if is-header-page() { header-style() } }
  )
  set heading(supplement: [Chapter])
  counter(page).update(1)
  matter

  // backmatter --
  counter(heading).update(0) // start at A.1
  set heading(numbering: "A.1.", supplement: [Appendix])
  backmatter

  // bibliography --
  if bibliography != none {
    bibliography
  }
}
