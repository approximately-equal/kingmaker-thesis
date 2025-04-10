// frontmatter =================================================================

#let title-page(title, author, date, presented-to, fullfillment) = {
  let margin = (x: 1.5in, top: 1.5in, bottom: 1.0in)
  set page(margin: margin)
  page({
    set align(center)
    set par(justify: false)
    v(1fr)
    text(size: 20pt)[#title]
    v(1fr)
    line(length: 50%)
    v(1fr)
    presented-to
    v(1fr)
    line(length: 50%)
    v(1fr)
    fullfillment
    v(1fr)
    line(length: 50%)
    v(1fr)
    text(style: "italic")[#author]
    v(1em)
    text(style: "italic")[#date.display("[month repr:short] [year]")]
    v(1fr)
  })
  // HACK: normal header function doesn't work here for some reason. Set blank page with no header.
  page(header: none)[]
}

#let signature-page(approval, advisors) = {
  let margin = (x: 1.5in, top: 1.5in, bottom: 1.0in)
  set page(margin: margin)
  page(margin: margin, {
    set align(center)
    v(50%)
    [#approval]
    v(1.2cm); line(length: 30%, stroke: 0.5pt)
    v(-0.4em)
    advisors.join(", ")
  })
  // HACK: normal header function doesn't work here for some reason. Set blank page with no header.
  page(header: none)[]
}

#let acknowledgments(acknowledgements) = {
  heading(level: 1, outlined: false, numbering: none)[Acknowledgements]
  acknowledgements
}

#let preface(preface) = {
  heading(level: 1, outlined: false, numbering: none)[Preface]
  preface
}

#let abbreviations(abbreviations) = {
  heading(level: 1, outlined: false, numbering: none)[Abbreviations]
  abbreviations
}

#let contents() = {
  outline(title: [Contents])
}

#let tables() = {
  outline(title: [List of Tables], target: figure.where(kind: table))
}

#let figures() = {
  outline(title: [List of Figures], target: figure.where(kind: image))
}

#let abstract(abstract) = {
  heading(level: 1, outlined: false, numbering: none)[Abstract]
  abstract
}

#let dedication(dedication) = {
  heading(level: 1, outlined: false, numbering: none)[Dedication]
  dedication
}

// #let frontmatter-hack() = {
//   // HACK: This prevents the page number from showing up on the blank page directly after the frontmatter. Why it happens at all is a mystery, but this works.
//   page(header: [])[]
// }
