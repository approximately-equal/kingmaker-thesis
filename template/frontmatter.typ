// utils =======================================================================
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

// frontmatter =================================================================
#let frontmatter(
  title,
  author,
  advisors,
  date,
  college,
  division,
  major,
  acknowledgements,
  preface,
  abbreviations,
  tables,
  figures,
  abstract,
  dedication,
) = {
  // cover page
  page({
    set align(center)
    v(1fr)
    title
    v(1fr); line(length: 50%, stroke: 0.5pt); v(1fr)
    [A Thesis \ Presented to \ The Division of #division \ #college]
    v(1fr); line(length: 50%, stroke: 0.5pt); v(1fr)
    [In Partial Fulfillment \ of the Requirements for the Degree \ Bachelor of Arts]
    v(1fr); line(length: 50%, stroke: 0.5pt); v(1fr)
    [#author \ #date.display("[month repr:short] [year]")]
    v(1fr)
  })
  pagebreak(to: "odd")

  // signature page
  page({
    set align(center)
  	v(50%)
  	[Approved for the Division \ (#major)]
   	v(1.2cm); line(length: 30%, stroke: 0.5pt)
    // #v(-0.5em)
    advisors.join(", ")
  })

  // acknowledgements
  if acknowledgements != none {
    page([
      #heading(level: 1, outlined: false, numbering: none)[Acknowledgements]
      #acknowledgements
    ])
  }

  // preface
  if preface != none {
    page([
      #heading(level: 1, outlined: false, numbering: none)[Preface]
      #preface
    ])

  }

  // abbreviations
  if abbreviations != none {
    page([
      #heading(level: 1, outlined: false, numbering: none)[Abbreviations]
      #abbreviations
    ])

  }

  // table of contents
  outline(
    title: [Table of Contents],
    indent: true,
  )

  // list of tables
  if tables {
    outline(
      title: [List of Tables],
      target: figure.where(kind: table),
    )
  }

  // list of figures
  if figures {
    outline(
      title: [List of Figures],
      target: figure.where(kind: image),
    )
  }

  // abstract
  if abstract != none {
    page([
      #heading(level: 1, outlined: false, numbering: none)[Abstract]
      #abstract
    ])

  }

  // dedication
  if dedication != none {
    page([
      #heading(level: 1, outlined: false, numbering: none)[Dedication]
      #dedication
    ])
  }
  // HACK: This prevents the page number from showing up on the blank page directly after the frontmatter. Why it happens at all is a mystery, but this works.
  page(header: [])[]
}
