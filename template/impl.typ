// imports =====================================================================

#import "packages/ctheorems.typ": *
#import "frontmatter.typ": title-page, signature-page

// functions ===================================================================

// create detectable pagebreaks chapter headers
#let sectionbreak() = {
  [#metadata(none) <empty-page-start>]
  pagebreak(weak: true, to: "odd")
  [#metadata(none) <empty-page-end>]
}

// check if this page should have a header
#let is-header-page() = {
  // setup selectors
  let matches-after = query(heading.where(level: 1).after(here()))
  let matches-before = query(heading.where(level: 1).before(here()))
  let current = counter(page).get()
  // check if this page has a chapter header
  let has-chapter-header = matches-after.any(m =>
  counter(page).at(m.location()) == current)
  // check if the page is blank (uses the detectable pagebreaks)
  let page-num = here().page()
  let is-page-break = query(<empty-page-start>)
  .zip(query(<empty-page-end>))
  .any(
    ((start, end)) => {
      (
        start.location().page() < page-num and page-num < end.location().page()
      )
    },
  )
  // determine whether the page should have a header on it
  return not has-chapter-header and not is-page-break
}

#let header-style(numbering) = {
  // get chapter for the given page
  let matches-before = query(heading.where(level: 1).before(here()))
  let current-chapter = if matches-before.len() > 0 {
    matches-before.last().body
  }
  // style the header
  if calc.odd(here().page()) {
    set align(left)
    counter(page).display(numbering) + h(1em) + smallcaps[#current-chapter]
  } else {
    set align(right)
    smallcaps[#current-chapter] + h(1em) + counter(page).display(numbering)
  }
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
  preview: false,
) = (body) => {
  // metadata --
  set document(title: title, author: author, date: date)

  // text --
  set text(font: ("Libertinus Serif"), size: 13pt, weight: 450)
  set par(
    justify: true, leading: 0.7em, spacing: 0.7em, first-line-indent: 1.5em,
  )
  show link: underline
  show link: set text(style: "oblique")

  // headings (general) --
  set heading(numbering: "1.", supplement: [Chapter])
  show heading: set text(style: "oblique", weight: "regular")
  show heading: set block(above: 2em, below: 1em)
  show heading: set par(justify: false) // overrides justification for headers

  // headings (per level)
  show heading.where(level: 1): it => {
    // create detectable pagebreaks chapter headers
    sectionbreak()
    // style chapter headers
    // set block(above: 0em)
    // NOTE: margin-top = 1.5in (header) + 1.0in (v)
    v(1in) + it
  }
  show heading.where(level: 1): set text(30pt)
  show heading.where(level: 2): set text(20pt)
  show heading.where(level: 3): set text(14pt)

  // page setup (headers, footers, layout) --
  set page(
    paper: "us-letter", margin: (inside: 1.5in, outside: 1.0in, top: 1.5in, bottom: 1.0in), header: context{
      if is-header-page() { header-style("i") }
    },
  )

  // frontmatter --
  if not preview {
    title-page(title, author, date, presented-to, fullfillment)
    signature-page(approval, advisors)
    // NOTE: for structure purposes (could OPTIONALLY have have acknowledgments + preface + abbreviations in front of it) the outline is not included here, but it is a REQUIRED element of the thesis and MUST be included.
  }

  // footnotes --
  set footnote.entry(indent: 0em, separator: line(length: 25%, stroke: 0.75pt), gap: 0.65em)
  show footnote.entry: set text(7.25pt)

  // mathematics --
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 1.5em)

  // figures & tables --
  set figure(supplement: [Fig])
  show figure.where(kind: table): set figure(supplement: [Table])
  show figure.where(kind: table): set align(left)

  // captions --
  show figure.caption: set align(left)
  show figure.caption: emph

  // lists & enums --
  show enum: set block(spacing: 1.5em)
  show list: set block(above: 1.5em)

  // raw text & code --
  show raw: set text(font: "Maple Mono", weight: "regular")
  show raw: set block(width: 100%)
  show raw.where(block: true): block.with(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
  )

  // packages --
  show: thmrules

  // main body --
  /// start main body at page 1 and reset heading numbering to decimal (frontmatter is numbered in roman numerals)
  set page(header: context{ if is-header-page() { header-style("1") } })
  counter(page).update(1)
  body

  // bibliography --
  // NOTE: for structure purposes the bibliography is not an argument to thesis, but it is a REQUIRED element of the thesis and MUST be included.
}
