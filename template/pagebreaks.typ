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

#let header-style() = {
  // get chapter for the given page
  let matches-before = query(heading.where(level: 1).before(here()))
  let current-chapter = if matches-before.len() > 0 {
    matches-before.last().body
  }
  // style the header
  if calc.odd(here().page()) {
    set align(right)
    smallcaps[#current-chapter] + h(1em) + counter(page).display()
  } else {
    set align(left)
    counter(page).display() + h(1em) + smallcaps[#current-chapter]
  }
}
