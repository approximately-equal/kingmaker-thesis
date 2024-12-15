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
    abstract: [],
    dedication: [To my parents, for their ceaseless support.],
    bib: bibliography("references.bib", title: [References], full: true)
)

// document ====================================================================
#include "chapters/1. Introduction.typ";
#include "chapters/2. Background.typ";
#include "chapters/3. Methods.typ";
#include "chapters/4. Results.typ";
#include "chapters/5. Discussion.typ";
#include "chapters/6. Appendix.typ";
