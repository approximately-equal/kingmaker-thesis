// imports --
#import "template/lib.typ" as reed-thesis

// thesis --
#show: reed-thesis.thesis(
  title: [Kingmaker: A Simulation Analysis of Strategic Voting],
  author: "Chance Addis",
  advisors: ("Michael Pearce",),
  date: datetime(year: 2025, month: 05, day: 19),
  program: (
    division: [Mathematical and Natural Sciences],
    major: [Mathematics - Statistics]
  ),
  frontmatter: [
    #include "contents/frontmatter/frontmatter.typ"
  ],
  matter: [
    #include "contents/matter/introduction.typ"
    #include "contents/matter/background.typ"
    #include "contents/matter/methods.typ"
    #include "contents/matter/results.typ"
    #include "contents/matter/discussion.typ"
  ],
  backmatter: [
    #include "contents/backmatter/symbols_and_definitions.typ"
    #include "contents/backmatter/code.typ"
  ],
  bibliography: bibliography(
    "references.yml",
    title: [References],
    style: "ieee"
  )
)
