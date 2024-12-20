// preamble ====================================================================
#import "template/lib.typ" as cfg
#import cfg.ctheorems: *

#show: cfg.thesis(
  title: [Kingmaker: A Simulation Analysis of Strategic Voting],
  author: "Chance Addis",
  advisors: ("Michael Pearce",),
  presented-to: [_A thesis presented to \ The Division of Mathematical and Natural Sciences \ Reed College_],
  fullfillment: [_Submitted in partial fulfillment of the requirements \   for the degree Bachelor of Arts_],
  approval: [Approved for the Division \ (Mathematics - Statistics)],
  date: datetime(year: 2025, month: 05, day: 01),
  // acknowledgements: [I would like to make some acknowledgements],
  abstract: [
    ...
  ],
  dedication: [To my parents, for their ceaseless support.],
  bib: bibliography("references.bib", title: [References], full: true),
  draft: true
)

// chapters ====================================================================
#include "chapters/introduction.typ";
#include "chapters/background.typ";
#include "chapters/methods.typ";
#include "chapters/results.typ";
#include "chapters/discussion.typ";

// appendix ====================================================================
#counter(heading).update(0)
#set heading(numbering: "A.1", supplement: [Appendix])
#include "appendix/a.typ";
