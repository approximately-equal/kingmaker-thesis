// preamble ====================================================================

// imports --
#import "template/lib.typ" as thesis-template
#import thesis-template.ctheorems: *

// template --
#show: thesis-template.thesis(
  title: [Kingmaker: A Simulation Analysis of Strategic Voting],
  author: "Chance Addis",
  advisors: ("Michael Pearce",),
  presented-to: [
    _A thesis presented to_ \
    _The Division of Mathematical and Natural Sciences_ \
    _Reed College_
  ],
  fullfillment: [
    _Submitted in partial fulfillment of the requirements_ \
    _for the degree Bachelor of Arts_
  ],
  approval: [
    _Approved for the Division_ \
    _(Mathematics - Statistics)_
  ],
  date: datetime(year: 2025, month: 05, day: 19),
)

// document ====================================================================

// frontmatter --
#include "sections/frontmatter/frontmatter.typ"

// matter --
#include "sections/chapters/introduction.typ"
#include "sections/chapters/background.typ"
#include "sections/chapters/methods.typ"
#include "sections/chapters/results.typ"
#include "sections/chapters/discussion.typ"

// backmatter --
#counter(heading).update(0) // start at A.1
#set heading(numbering: "A.1", supplement: [Appendix])
#include "sections/appendices/symbols_and_definitions.typ"
#include "sections/appendices/code.typ"

#bibliography("references.yml", title: [References], full: true, style: "ieee") // NOTE: this is required
