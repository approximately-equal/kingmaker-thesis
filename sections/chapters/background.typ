= Background <background>

#lorem(100)

== A History of Social Choice

Social choice has been applied since humanity has existed. After all there has always been a need to make collective decisions. The theory however, is more modern. The two scholars typically credited with the development of social choice theory is Nicolas de Condorcet (1743–1794) and Kenneth Arrow (1921–2017).

== A Formalization of Social Choice

At its core, social choice theory is concerned with the analysis of _preference aggregation_, understood to be the aggregation of individual preferences, each of which compares two or more social alternatives, into a single collective preference (or choice). The basic framework, which is still standard, was introduced by _Kenneth Arrow_ in 1951.

=== Basic Framework

Let $N = {1, 2, dots}$ be a set of $n$ individuals ($n >= 2$), and $A = {cal(a), cal(b), dots}$ be a set of $m$ social alternatives, such as candidates, policies, goods, etc. Each individual $v_i$ has a _preference ordering_ $P_i$ over these alternatives. A _preference ordering_ is defined by a complete, total order on $X$ known as a _weak preference_. It is written with the symbol $prec.eq, succ.eq$, where $cal(a) prec.eq cal(b)$ is defined as $cal(a)$ is preferred or indifferent to $cal(b)$. There are also shorthands for _strict preference_ ($cal(a) prec cal(b) := cal(a) prec.eq cal(b) and cal(b) prec.eq.not cal(a)$) and _strict indifference_ ($cal(a) ~ cal(b) := cal(a) prec.eq cal(b) and cal(b) prec.eq cal(a)$)

#footnote[
  Here I forgo the more general formalism of _preference aggregation rule_ in favor of the more specific case of _social welfare functions_. The term _social welfare function_ is a specific type of preference aggregation rule that _always_ produces a complete social ranking of alternatives. For the scope of this thesis, social welfare functions are more suitable.
]
A collection of preference orderings across a set of individuals ${P_1, P_2, dots, P_n angle.r}$, is called a _profile_. A _social welfare function_ is a function $W : P -> A$

#highlight[continue here]

== A Model of Voting

=== Conceptualization of Ballots

So far, the only conception of voting has been with _preferences_. But do voters actually submit their ballots deterministically? No. It's unrealistic to assume that voters always vote rationally in a predefined way. There is an element of randomness in the voting process. Say that a voter has the following opinions: $cal(a) = 65% "approval"$ and $cal(b) = 35% "approval"$. The voter may submit a ballot with $cal(a) prec cal(b)$ or $cal(b) prec cal(a)$ depending on how they feel on the day of the election. Voting is a _stochastic process_.

This conceptualization facilitates the need to disambiguate a _preference_ from a _ballot_.#footnote[Here I redefine preference to a new definition and define ballot in its place.] A preference is redefined as a distribution over preference orderings, and a ballot is a realization of that distribution. Think of a preference like a superposition, and when the election is held, the preference collapses into a ballot.

Stochastic voting is a concept hardwired into the framework of this thesis, as all the methods for generating ballots are stochastic. This framing allows us to conceptualize these _synthesizers_ as voters who non-deterministically submit their ballots via some set of rules. Granted those rules might be "randomly select an ordering of candidates", but it's still of the same process as real voting.

=== Strategic Voting

#highlight[continue here]
