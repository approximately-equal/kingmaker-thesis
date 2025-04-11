// preamble ====================================================================

// imports --
#import "template/lib.typ" as reed-thesis
#import reed-thesis.ctheorems: *

// template --
#show: reed-thesis.thesis(
  title: [Kingmaker: A Simulation Analysis of Strategic Voting],
  author: "Chance Addis",
  advisors: ("Michael Pearce",),
  presented-to: [
    _A Thesis_ \
    _Presented to_ \
    _The Division of Mathematical and Natural Sciences_ \
    _Reed College_
  ],
  fullfillment: [
    _In partial fulfillment_ \
    _of the Requirements for the degree_ \
    _Bachelor of Arts_
  ],
  approval: [
    Approved for the Division \
    (Mathematics - Statistics)
  ],
  date: datetime(year: 2025, month: 05, day: 19),
)

// document ====================================================================

// frontmatter --
#include "contents/frontmatter/frontmatter.typ"

// matter --
#counter(page).update(0)
#include "contents/matter/introduction.typ"
#include "contents/matter/background.typ"
#include "contents/matter/methods.typ"
#include "contents/matter/results.typ"
#include "contents/matter/discussion.typ"

// backmatter --
#counter(heading).update(0) // start at A.1
#set heading(numbering: "A.1.", supplement: [Appendix])
#include "contents/backmatter/symbols_and_definitions.typ"
#include "contents/backmatter/code.typ"

#bibliography(
  "references.yml",
  title: [References],
  full: true,
  style: "ieee"
) // NOTE: this is required
