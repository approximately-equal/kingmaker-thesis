// imports =====================================================================

#import "packages/ctheorems.typ": *
#import "frontmatter.typ": *
#import "packages/gentle-clues.typ": gentle-clues
#import "packages/drafting.typ" as drafting
#import "packages/codly.typ" as codly
#import "@preview/marge:0.1.0": sidenote, container

// setup =======================================================================

// sizes
#let text-size = 12pt

// spaces
#let line-spacing = 0.75em
#let heading-spacing = 1.5em

// page setup
#let (
  inside-margin,
  outside-margin,
  top-margin,
  bottom-margin
) = (1.5in, 1.0in, 1.5in, 1.0in)

// headings
// level = 1
#let chapter-style(num, title) = {
  // create detectable pagebreaks---for the headers---to a odd page
  [#metadata(none) <empty-page-start>]
  pagebreak(weak: true, to: "odd")
  [#metadata(none) <empty-page-end>]
  // style the chapter
  if num != none {
    let chapter-num = counter(heading).display()
    block(below: 0.5em)[#text(chapter-num, weight: "black", 60pt)];
    // v(0.2em)
   linebreak()
  }
  text(title, style: "oblique", weight: "regular", size: 25pt)
  block(below: heading-spacing)[#line(length: 100%, stroke: 0.2pt)]
}
// level > 1
#let section-style(num, title) = {
  // universal style for sections...
  par()[#num#h(1em)#title]
  set block(spacing: heading-spacing)
  let num = text(style: "italic", size: 10pt,
    numbering(num, ..counter(heading).at(here())) + [#h(1em)\u{200b}]
  )
  let x-offset = -1 * measure(num).width
  pad(left: x-offset,
    par(hanging-indent: -1 * x-offset,
      text(style: "italic", size: 10pt, num) + title
    )
  )
}

// header
// check if this page should have a header on it
#let is-header-page() = {
  // setup selectors
  let matches-after = query(heading.where(level: 1,).after(here()))
  let matches-before = query(heading.where(level: 1,).before(here()))
  let current = counter(page).get()
  // check if this page has a chapter haeder
  let has-chapter-header = matches-after.any(m =>
    counter(page).at(m.location()) == current
  )
  // check if the page is blank
  let page-num = here().page()
  let is-page-break = query(<empty-page-start>)
    .zip(query(<empty-page-end>))
    .any(((start, end)) => {
      (start.location().page() < page-num
        and page-num < end.location().page())
    })
  // return whether thet page should have a header on it
  return not has-chapter-header and not is-page-break
}
// add style to the header
#let header-style() = {
  let matches-before = query(heading.where(level: 1,).before(here()))
  let current-chapter = if matches-before.len() > 0 {matches-before.last().body} else {none}
  if calc.odd(here().page()) {
    set align(left)
    smallcaps[#counter(page).display()#h(1em)#current-chapter]
  } else {
    set align(right)
    smallcaps[#current-chapter#h(1em)#counter(page).display()]
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
  acknowledgements: none,
  preface: none,
  abbreviations: none,
  tables: false,
  figures: false,
  abstract: none,
  dedication: none,
  bib: none,
  draft: false
) = (body) => {
  // metadata
  set document(title: title, author: author, date: date)

  // text --
  set text(size: text-size, weight: 450)
  set par(justify: true, leading: line-spacing, first-line-indent: 0.0em, spacing: 1.2em)

  // headings --
  set heading(numbering: "1.1")
    show heading: set text(weight: 450, size: text-size)
    show heading: it => context {
      // chapter headings are handled separately
      if it.level == 1 {
        chapter-style(it.numbering, it.body)
        return
      }
      // return default if numbering is zero AND level != 1,
      // if level = 1, then its the same regardless of numbering
      if it.numbering == none { return it }
      // levels > 1
      section-style(it.numbering, it.body)
    }

  // frontmatter --
  if not draft {
    set page(paper: "us-letter", margin: (x: inside-margin)) // frontmatter is centered and no headers
    frontmatter(title, author, advisors, date, college, presented-to, fullfillment, approval, acknowledgements, preface, abbreviations, tables, figures, abstract, dedication)
  }

  // page setup (headers, footers, layout) --
  set page(
    paper: "us-letter",
    margin: (
      inside: inside-margin,
      outside: outside-margin,
      top: top-margin,
      bottom: bottom-margin
    ),
    header: context { if is-header-page() { header-style() } },
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

  set figure.caption(position: bottom)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: set align(left)
  show figure.caption: set par(first-line-indent: 0em)
  show figure.caption: (it) => [
    *#it.supplement #it.counter.display()*#it.separator;#it.body
  ]

  // lists --
  show enum: set block(spacing: 1.5em)
  show list: set block(above: 1.5em)

  // packages --
  show: thmrules
  show: gentle-clues
  show: codly.codly-init.with()
  // drafting.set-page-properties(
  //   left-margin: 1.5in,
  //   right-margin: 1.5in,
  // )
  // place(drafting.set-page-properties())

  // main body --
  counter(page).update(1) // page 1 is the introduction
  body

  // bibliography --
  if not draft {
    bib
  }
}
