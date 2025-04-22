#import "../../template/lib.typ": frontmatter

#frontmatter.contents() // NOTE: this is required

#frontmatter.figures()

#frontmatter.tables()

#frontmatter.abstract[
  The Gibbard–Satterthwaite Theorem establishes that any non-dictatorial voting rule with at least three alternatives is inherently vulnerable to strategic manipulation. This work examines the practical consequences of this theorem by analyzing the susceptibility of various voting methods under a range of social conditions and models of voter behavior. To support this analysis, a modular and performant simulation framework---`kingmaker`---is developed for modeling elections across diverse strategic environments and preference distributions. Using `kingmaker`, this work offers a systematic evaluation of the frequency, impact, and structure of strategic voting across multiple electoral systems. The results yield empirical insight into the robustness of these systems and identify the conditions under which theoretical manipulability becomes operationally significant.
]

#frontmatter.dedication[To my parents, for their ceaseless support.]

// NOTE: If this doesn't exist, the empty page after the frontmatter and before the matter, there will be a heading, _which is a BUG_. I have no idea why this is happening, and I can't be bothered to fix it. The hack works, don't question it.
#page(header: [], footer: [])[]
