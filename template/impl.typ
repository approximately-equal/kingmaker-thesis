// imports =====================================================================
#import "packages/ctheorems.typ": *
#import "frontmatter.typ": *
#import "packages/gentle-clues.typ": gentle-clues
#import "packages/drafting.typ" as drafting
#import "packages/codly.typ" as codly

// utilities ===================================================================
#let detectable-pagebreak(to: "odd") = {
  [#metadata(none) <empty-page-start>]
  pagebreak(weak: true, to: to)
  [#metadata(none) <empty-page-end>]
}

#let is-page-break() = {
  let page-num = here().page()
  query(<empty-page-start>)
    .zip(query(<empty-page-end>))
    .any(((start, end)) => {
      (start.location().page() < page-num
        and page-num < end.location().page())
    })
}

// thesis ======================================================================
#let thesis(
  title: [Thesis Title],
  author: "Student",
  advisors: ("Advisor", ),
  date: datetime.today(),
  college: "Reed College",
  division: "Division",
  major: "Major",
  acknowledgements: none,
  preface: none,
  abbreviations: none,
  tables: false,
  figures: false,
  abstract: none,
  dedication: none,
  bib: none,
) = (body) => {
  // metadata
  set document(title: title, author: author, date: date)

  // text
  set text(font: ("New Computer Modern",), size: 13pt, weight: 450)
  set par(justify: true)
  set par(leading: 0.78em, first-line-indent: 0.0em)

  // headings
  set heading(numbering: "1.")
  show heading: set text(font: "Al Bayan")
  show heading.where(level: 1): it => {
    detectable-pagebreak(to: "odd")
    v(4em)
    text(it, 2em)
  }
  show heading.where(level: 2): set text(1.5em)
  show heading.where(level: 3): set text(1.4em)
  show heading.where(level: 4): set text(1.2em)

  // frontmatter
  frontmatter(title, author, advisors, date, college, division, major, acknowledgements, preface, abbreviations, tables, figures, abstract, dedication)

  // page setup
  set page(paper: "a4", margin: (inside: 1.5in, outside: 1.0in, top: 1.5in, bottom: 1.0in), header: context {
    // setup selectors
    let matches-after = query(heading.where(level: 1,).after(here()))
    let matches-before = query(heading.where(level: 1,).before(here()))
    let current = counter(page).get()
    // check if this page has a chapter haeder
    let has-chapter-header = matches-after.any(m =>
      counter(page).at(m.location()) == current
    )
    // get the current chapter
    let current-chapter = if matches-before.len() > 0 {matches-before.last().body} else {none}
    // determine if this is a pagebreak
    let is-page-break = is-page-break()
    if not has-chapter-header and not is-page-break {
      align(if calc.odd(here().page()) {right} else {left}, emph[#here().page(). #h(0.2em) #current-chapter])
    }
  })

  // mathematics
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 1.5em)

  // footnotes
  set footnote.entry(
    indent: 0em,
    separator: line(length: 25%, stroke: 0.75pt),
    gap: 0.65em
  )
  show footnote.entry: set text(7.25pt)

  // figures
  set figure(supplement: [Fig.])
  set figure(placement: auto, gap: 1em)
  show figure.caption: set text(size: 8pt)
  show figure.where(placement: auto): set place(clearance: 1.5em)
  show figure.where(kind: table): set figure(supplement: [Table])

  set figure.caption(position: bottom)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: set align(left)
  show figure.caption: set par(first-line-indent: 0em)
  show figure.caption: (it) => [
    *#it.supplement #it.counter.display()*#it.separator;#it.body
  ]

  show table: set text(size: 8pt)

  // lists
  show enum: set block(spacing: 1.5em)
  show list: set block(spacing: 1.5em)

  // packages
  show: thmrules
  show: gentle-clues
  show: codly.codly-init.with()
  // place(drafting.set-page-properties())

  // main body
  body

  // bibliography
  show bibliography: set par(first-line-indent: 0em)
  show bibliography: set block(spacing: 1em)
  show bibliography: it => {
    show heading: set block(above: 3em, below: 1.5em)
    it
  }
  bib
}
