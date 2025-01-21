// imports =====================================================================
#import "packages/ctheorems.typ": *
#import "frontmatter.typ": *
#import "packages/gentle-clues.typ": gentle-clues
#import "packages/drafting.typ" as drafting
#import "packages/codly.typ" as codly

// functions ===================================================================
#let is-header-page() = {
  // setup selectors
  let matches-after = query(heading.where(level: 1,).after(here()))
  let matches-before = query(heading.where(level: 1,).before(here()))
  let current = counter(page).get()
  // check if this page has a chapter haeder
  let has-chapter-header = matches-after.any(m =>
    counter(page).at(m.location()) == current
  )
  // check if the page is blank (uses the detectable pagebreaks)
  let page-num = here().page()
  let is-page-break = query(<empty-page-start>)
    .zip(query(<empty-page-end>))
    .any(((start, end)) => {
      (start.location().page() < page-num
        and page-num < end.location().page())
    })
  // determine whether the page should have a header on it
  return not has-chapter-header and not is-page-break
}

// thesis ======================================================================
#let thesis(
  title: [Thesis Title],
  author: "Student",
  advisors: ("Advisor",),
  date: datetime.today(),
  college: [Reed College],
  presented-to: [A Thesis \ Presented to \ (Division) \ (College)],
  fullfillment: [],
  approval: [Approved for the Division \ (Major)],
  acknowledgements: none,
  preface: none,
  abbreviations: none,
  tables: false,
  figures: false,
  abstract: none,
  dedication: none,
  bib: none,
  preview: false
) = (body) => {
  // metadata
  set document(title: title, author: author, date: date)

  // text --
  set text(size: 13pt, weight: 450)
  set par(
    justify: true,
    leading: 0.7em,
    spacing: 0.7em,
    first-line-indent: 1.5em
  )

  // headings (general) --
  set heading(numbering: "1.")
  show heading: set text(style: "oblique", weight: "regular")
  show heading: set block(above: 2em, below: 1em)
  show heading: set par(justify: false) // overrides justification for headers

  // headings (per level)
  show heading.where(level: 1): it => {
    // create detectable pagebreaks chapter headers
    [#metadata(none) <empty-page-start>]
    pagebreak(weak: true, to: "odd")
    [#metadata(none) <empty-page-end>]
    // style chapter headers
    // set block(above: 0em)
    // NOTE: margin-top = 1.5in (header) + 1.0in (v)
    v(1in) + it
  }
  show heading.where(level: 1): set text(30pt)
  show heading.where(level: 2): set text(20pt)
  show heading.where(level: 3): set text(18pt)

  // frontmatter --
  if not preview {
    // frontmatter is centered with 1.5in margins and has no headers
    set page(paper: "us-letter", margin: (x: 1.5in, top: 1.5in, bottom: 1.0in))
    frontmatter(title, author, advisors, date, college, presented-to, fullfillment, approval, acknowledgements, preface, abbreviations, tables, figures, abstract, dedication)
  }

  // page setup (headers, footers, layout) --
  set page(
    paper: "us-letter",
    margin: (inside: 1.5in, outside: 1.0in, top: 1.5in, bottom: 1.0in),
    header: context { if is-header-page() {
      // get chapter for the given page
      let matches-before = query(heading.where(level: 1,).before(here()))
      let current-chapter = if matches-before.len() > 0 {
        matches-before.last().body
      }
      // style the header
      let dot = h(0.2em) + $dot$ + h(0.2em)
      if calc.odd(here().page()) {
        set align(left)
        counter(page).display() + dot + smallcaps[#current-chapter]
      } else {
        set align(right)
        smallcaps[#current-chapter] + dot + counter(page).display()
      }
    }}
  )

  // footnotes --
  set footnote.entry(
    indent: 0em,
    separator: line(length: 25%, stroke: 0.75pt),
    gap: 0.65em
  )
  show footnote.entry: set text(7.25pt)

  // mathematics --
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 1.5em)

  // figures --
  set figure(supplement: [Fig.])
  set figure(placement: auto, gap: 1em)
  show figure.caption: set text(size: 8pt)
  show figure.where(placement: auto): set place(clearance: 1.5em)
  show figure.where(kind: table): set figure(supplement: [Table])

  // captions --
  set figure.caption(position: bottom)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: set align(left)
  show figure.caption: set par(first-line-indent: 0em)
  show figure.caption: (it) => [
    *#it.supplement #it.counter.display()*#it.separator;#it.body
  ]

  // lists & enums --
  show enum: set block(spacing: 1.5em)
  show list: set block(above: 1.5em)

  // packages --
  show: thmrules
  show: gentle-clues
  show: codly.codly-init.with()
  // previewing.set-page-properties(
  //   left-margin: 1.5in,
  //   right-margin: 1.5in,
  // )
  // place(drafting.set-page-properties())

  // main body --
  // start main body at page 1 (frontmatter is not numbered)
  counter(page).update(1)
  body

  // bibliography --
  if not preview {
    bib
  }
}
