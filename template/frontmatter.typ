// prelimanary =================================================================

// title page of thesis
#let title-page(title, author, date, program) = {
  let margin = (x: 1.5in, top: 1.5in, bottom: 1.0in)
  set page(margin: margin)
  page({
    set align(center)
    set par(justify: false)
    v(1fr)
    title
    v(1fr)
    line(length: 50%)
    v(1fr)
    [
      A Thesis \
      Presented to \
      The Division of #program.division \
      Reed College
    ]
    v(1fr)
    line(length: 50%)
    v(1fr)
    [
      In partial fulfillment \
      of the Requirements for the degree \
      Bachelor of Arts
    ]
    v(1fr)
    line(length: 50%)
    v(1fr)
    author
    v(1em)
    date.display("[month repr:short] [year]")
    v(1fr)
  })
  // HACK: normal header function doesn't work here for some reason. Set blank page with no header.
  page(header: none)[]
}

// signature page of thesis
#let signature-page(advisors, program) = {
  let margin = (x: 1.5in, top: 1.5in, bottom: 1.0in)
  set page(margin: margin)
  page(margin: margin, {
    set align(center)
    v(50%)
    [
      Approved for the Division \
      (#program.major)
    ]
    v(1.2cm); line(length: 30%, stroke: 0.5pt)
    v(-0.4em)
    advisors.join(", ")
  })
  // HACK: normal header function doesn't work here for some reason. Set blank page with no header.
  page(header: none)[]
}

// frontmatter =================================================================

#let frontmatter(
  acknowledgements: none,
  preface: none,
  abbreviations: none,
  figures: false,
  tables: false,
  raws: false,
  abstract: none,
  dedication: none,
  hack: true,
) = {
  if acknowledgements != none {
    heading(level: 1, outlined: false, numbering: none)[Acknowledgements]
    acknowledgements
  }

  if preface != none {
    heading(level: 1, outlined: false, numbering: none)[Preface]
    preface
  }

  if abbreviations != none {
    heading(level: 1, outlined: false, numbering: none)[Abbreviations]
    abbreviations
  }

  outline(title: [Contents])

  if figures == true {
    outline(title: [List of Figures], target: figure.where(kind: image))
  }

  if tables == true {
    outline(title: [List of Tables], target: figure.where(kind: table))
  }

  if raws == true {
    outline(title: [List of Code], target: figure.where(kind: raw))
  }

  if abstract != none {
    heading(level: 1, outlined: false, numbering: none)[Abstract]
    abstract
  }

  if dedication != none {
    heading(level: 1, outlined: false, numbering: none)[Dedication]
    dedication
  }

  // HACK: This prevents the page number from showing up on the blank page directly after the frontmatter. Why it happens at all is a mystery, but this works.
  if hack {
    page(header: [])[]
  }
}
