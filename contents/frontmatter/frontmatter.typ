#import "../../template/lib.typ": frontmatter

#frontmatter.contents() // NOTE: this is required

#frontmatter.figures()

#frontmatter.tables()

#frontmatter.abstract[
  In social choice theory, the Gibbard–Satterthwaite Theorem establishes that every non-trivial, non-dictatorial voting system is susceptible to strategic manipulation. In other words, for any such system, there _does not exists_ a dominant strategy---including honest voting---for any voter who aims to maximize their social welfare. Consequently, all practical voting methods must contend with the reality of strategic behavior and its implications for collective decision-making.

  There have been efforts such as #highlight[...] that aim to measure how resilient a voting method is to certain kinds of strategic voting, but #highlight[...]

  This thesis expands upon this literature by simulating complex social conditions, in order to:

  + Synthesize optimal (in some measurable sense) strategies for some voter bloc,
  + Use those novel (as well as known) voting strategies to compare the resilience of common voting methods across a range of social conditions.
]

#frontmatter.dedication[To my parents, for their ceaseless support.]
