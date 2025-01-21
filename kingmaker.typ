// preamble ====================================================================
#import "template/lib.typ" as cfg
#import cfg.ctheorems: *
#import "@preview/marge:0.1.0": sidenote


#show: cfg.thesis(
  title: [Kingmaker: A Simulation Analysis of Strategic Voting],
  author: "Chance Addis",
  advisors: ("Michael Pearce",),
  presented-to: [_A thesis presented to \ The Division of Mathematical and Natural Sciences \ Reed College_],
  fullfillment: [_Submitted in partial fulfillment of the requirements \   for the degree Bachelor of Arts_],
  approval: [_Approved for the Division \ (Mathematics - Statistics)_],
  date: datetime(year: 2025, month: 05, day: 01),
  abstract: [
    In the field of social choice theory, The _Gibbard-Satterthwaite Theorem_ tells us that any all _non-trivial, non-dictatorial_ voting methods do _not_ have a _dominant strategy_ for any individual voter. Thus every voting system which follows these axioms (which they should) must be _manipulable_. Thus any voting method must consider how voters will _strategically vote_ in order to benefit their _social welfare_. There have been efforts such as ... that aim to measure how resilient a voting method is to certain kinds of strategic voting.

    My thesis expands upon this literature by simulating complex social conditions in order to:

    1. Synthesize optimal (in some measurable sense) strategies (for some subset of voter base),
    2. Use those novel (as well as known) voting strategies to compare the resilience of common voting methods, and
    3. ...

  ],
  dedication: [To my parents, for their ceaseless support.],
  bib: bibliography("references.bib", title: [References], full: true),
  // draft: true
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
#include "appendix/symbols_and_definitions.typ";
