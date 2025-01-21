// frontmatter =================================================================
#let frontmatter(
  title,
  author,
  advisors,
  date,
  college,
  presented-to,
  fullfillment,
  approval,
  acknowledgements,
  preface,
  abbreviations,
  tables,
  figures,
  abstract,
  dedication,
) = {
  // cover page --

  // basic
  // page({
  //   set align(center)
  //   v(1fr)
  //   title
  //   v(1fr); line(length: 50%, stroke: 0.5pt); v(1fr)
  //   presented-to
  //   v(1fr); line(length: 50%, stroke: 0.5pt); v(1fr)
  //   fullfillment
  //   v(1fr); line(length: 50%, stroke: 0.5pt); v(1fr)
  //   [#author \ #date.display("[month repr:short] [year]")]
  //   v(1fr)
  // })
  // pagebreak(to: "odd")

  // fancy
  page({
    set align(center)
    set par(justify: false)
    v(1fr)
    text(size: 20pt)[#title]
    v(0.5fr)
    author
    v(0.1em)
    date.display("[month repr:short] [year]")
    v(0.2fr)
    presented-to
    v(1em)
    fullfillment
    v(1fr)
  })
  pagebreak(to: "odd")

  // signature page --
  page({
    set align(center)
  	v(50%)
  	[#approval]
   	v(1.2cm); line(length: 30%, stroke: 0.5pt)
    v(-0.4em)
    advisors.join(", ")
  })

  // acknowledgements --
  if acknowledgements != none {
    heading(level: 1, outlined: false, numbering: none)[Acknowledgements]
    acknowledgements
  }

  // preface --
  if preface != none {
    heading(level: 1, outlined: false, numbering: none)[Preface]
    preface

  }

  // abbreviations --
  if abbreviations != none {
    heading(level: 1, outlined: false, numbering: none)[Abbreviations]
    abbreviations
  }

  // style outline entries --
  show outline.entry: it => if (it.level == 1) { smallcaps(it) } else { it }

  // table of contents --
  outline(
    title: [Contents],
    indent: true,
  )

  // list of tables --
  if tables {
    outline(
      title: [List of Tables],
      target: figure.where(kind: table),
    )
  }

  // list of figures --
  if figures {
    outline(
      title: [List of Figures],
      target: figure.where(kind: image),
    )
  }

  // abstract --
  if abstract != none {
    heading(level: 1, outlined: false, numbering: none)[Abstract]
    abstract
  }

  // dedication --
  if dedication != none {
    heading(level: 1, outlined: false, numbering: none)[Dedication]
    dedication
  }
  // HACK: This prevents the page number from showing up on the blank page directly after the frontmatter. Why it happens at all is a mystery, but this works.
  page(header: [])[]
}
