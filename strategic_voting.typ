// preamble ====================================================================
#import "template/lib.typ" as cfg
#import cfg.ctheorems: *

#show: cfg.thesis(
    title: [The Voting Game: A Simulation Analysis of Strategic Voting],
    author: "Chance Addis",
    advisors: ("Michael Pearce",),
    division: [Mathematical and Natural Sciences],
    major: [Mathematics - Statistics],
    date: datetime(year: 2025, month: 05, day: 01),
    acknowledgements: [I would like to make some acknowledgements],
    abbreviations: [Here are some abbreviations],
    abstract: [This is an abstract],
    dedication: [To my parents, for their ceaseless support.],
    bib: bibliography("references.bib", title: [References], full: true)
)

// document ====================================================================
// #include "chapters/introduction.typ";
// #include "chapters/background.typ";
// #include "chapters/methods.typ";
// #include "chapters/results.typ";
// #include "chapters/discussion.typ";
// #include "chapters/appendix.typ";

= Introduction
#lorem(500)

= Background
#lorem(1000)

= Methods
#lorem(800)

= Results
#lorem(700)

= Discussion
#lorem(600)

= Afterward
#lorem(1400)
