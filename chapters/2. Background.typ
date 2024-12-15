// 2. Background ===============================================================
= Background <background>
In this chapter, all the background theory will be introduced. This should cover: social choice, and likely game theory and optimization as well.

== Election Systems
This section builds the foundational ideas of voting methods and the axioms and structure that we want them to have. It should also discuss some of the theorems that already bound what is possible to have in a voting system (_Arrow_, _Gibbard-Satterwaite_). It should be structured like so:

=== Axioms:
There are infinite ways to convert ballots into a "winner". But what characteristics do we want this "voting function" to have. This sub-section talks about some of the axioms that voting systems should ideally have, why we want them, and what they each mean. It should impress the significant of the _social welfare function_ as a mathematical object that underpins the core of strategic voting.

=== Social Choice Theorems:
Having discussed some of the axioms that we'd ideally want to have, this sub-section breaks that idyllic view to discuss the boundaries of what is achievable in a voting system. Thus we introduce _Arrow's Impossibility Theorem_. We then turn to the social welfare function, and discuss the _Gibbard-Satterwaite Theorem_ and why strategic voting is inherent to all forms of voting.


=== Voting Methods:
With some theory under our belts, this sub-section begins to introduce some of the actual methods that are used for real voting. We discuss their implementations, their characteristics (with respect to the social choice axioms), and their usage (how they are used and what inputs and outputs they give).

There is also room to add some less common, novel and unused methods which can then be compared to the more established methods.

== How Voters Vote?
In this section, we narrow in on strategic voting and the methods by which voters vote. This section asks how voters convert their complex preferences of each candidate and convert them into concrete ballots.

There should be discussion of the following types of voting: honest, strategic (deterministic), strategic (stochastic / noise), and mixed models.

We should of course reiterate why voters strategically vote and how then tend to do so.

=== Preferences $->$ Ballots
This sub-section should talk about how preferences, which we describe as the jumble of opinions that a voter holds of each candidate, is converted into a (honest) ballot through a stochastic process. For example, we might conceptualize a voter who needs to rank the candidates as having some abstract distribution of "likability" for each candidate. Then on election day, they "draw" from that distribution and the order of those "likability" ratings is their ranked ballot.

// === Preferences $->$ Ballots
//   + What do we know about how voters turn their preferences into ballots?
//   + What are historical models for voter behavior, and what are their merits?
//   + How will we model voter behavior in this thesis?
//   + What is the difference between a preference and a ballot?

=== Strategic Voting Interactions
This sub-section is where we discuss how the preferences to ballots process interacts with the process of strategic voting (conceptually). How should we consider these processes given that they happen in parallel and influence each other. A true preferences are likely to be influenced by knowledge of the environment, i.e. strategic voting.

=== History of Strategic Voting
This section breaks down some of the history behind strategic voting. We look back into past elections to determine (1) Historically, how have voters strategically altered their votes? What strategies do they tend to use? (2) When (if ever) has strategic voting influenced elections? How?

=== Optimal Strategy
This is the section where we dig into the idea of optimal strategy with respect to social welfare. Before the methods section, this section introduced the fundamental goals and characteristics that optimal strategies should have. hat does it mean for a strategic voting function to be "optimal"?

This section should also dovetail nicely into the methods section, which will discuss the implementation and framework that we will use the model strategic voting and analyze its efficacy.
