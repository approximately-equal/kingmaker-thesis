= Background <background>

== A History of Social Choice <history> // =====================================

Social choice has been applied since humanity has existed. After all there has always been a need to make collective decisions. Its theory, however, is more modern, and tracks changes in our values and methodologies around collective action and voting.

=== Precursors <precursors>

Early social choice theory was far more concerned with voting as a procedure than of social welfare as an ideal.

Here we find one of the earliest recorded instances of voting manipulation. Pliny deliberately changed the voting rules so that execution would have split the vote between exile and execution, leading to acquittal. In response the voters changed strategies and voted for the second best option.

Other notable precursors include Catalan Ramon Lull (1232--1316) and the German Nikolaus von Kues (1401--1464). Ramon Lull produced, among other things, what is now now as Copeland (or Lull's) method, in which the winner is the candidate with the most pairwise wins against other candidates via ranked ballots. Von Kues is known for proposing what is now known as Borda's method, a method that we will discuss shortly.

=== The Math of Consensus <consensus>

Jean-Charles de Borda (1733--1799) and Nicolas de Condorcet (1743--1794) are considered the modern founders of social choice theory. They are distinguished from their precursors by the mathematical nature of their analysis.

Of the two, Borda's contributions are the more limited, having only written few pages. In that space he outlined the Borda count, a Condorcet method---which we'll discuss in just a moment---where the each candidate is assigned a score defined as the aggregate points assigned by their placement on each ballot. (With $k$ options, rank 1 gets $k-1$ points, rank 2 gets $k-2$, etc.) The candidates with the most points wins. In the same article, he also shows that the plurality method is flawed, given that it can select a pairwise loser to all other candidates (i.e. a Condorcet loser).

Condorcet alternatively devotes an entire books---along with several papers---worth of material on voting in his _Essay on the Application of Analysis to the Probability of Majority Decisions_ [translated from the native French]. In his work, Condorcet establishes many notable results, including Condorcet's jury theorem and Condorcet's paradox.

Condorcet's jury theorem proves that if each jury member is more likely than not to make a correct verdict, then the probability that the majority verdict is correct increases as the number of jury members increases.

Condorcet's paradox, a fundamental property of majority rule, states that with more than 2 candidates plurality methods can become intransitive (_not_ transitive)---it's possible for $A$ to pairwise beat $B$, $B$ to pairwise beat $C$, _and_ $C$ to pairwise beat $A$.

#highlight[Note Charles Dodgson (Lewis Carroll) here]

=== Welfare Economics <welfare-economics>

#highlight[Add Arrow + Gibbard-Satterthwaite here]


== A Formalization of Social Choice <formalization> // =========================

At its core, social choice theory is concerned with the analysis of _preference aggregation_, understood to be the aggregation of individual preferences, each of which compares two or more social alternatives, into a single collective preference (or choice). The basic framework, which is still standard, was introduced by Kenneth Arrow in 1951.

=== Basic Framework <framework>

Let $N = {1, 2, dots}$ be a set of $n$ individuals ($n >= 2$), and $A = {pi_1, pi_2, dots}$ be a set of $m$ social alternatives, such as candidates, policies, goods, etc. Each individual $v_i$ has a _preference ordering_ $P_i$ over these alternatives. A _preference ordering_ is defined by a complete, total order on $X$ known as a _weak preference_. It is written with the symbol $prec.eq, succ.eq$, where $pi_1 prec.eq pi_2$ is defined as $pi_1$ is preferred or indifferent to $pi_2$. There are also shorthands for _strict preference_ ($pi_1 prec pi_2 := pi_1 prec.eq pi_2 and pi_2 prec.eq.not pi_1$) and _strict indifference_ ($pi_1 ~ pi_2 := pi_1 prec.eq pi_2 and pi_2 prec.eq pi_1$)

#footnote[
  Here I forgo the more general formalism of _preference aggregation rule_ in favor of the more specific case of _social welfare functions_. The term _social welfare function_ is a specific type of preference aggregation rule that _always_ produces a complete social ranking of alternatives. For the scope of this thesis, social welfare functions are more suitable.
]

A collection of preference orderings across a set of individuals ${P_1, P_2, dots, P_n angle.r}$, is called a _profile_. A _social welfare function_ is a function $W : P -> A$ #highlight[...]

=== Classical Social Choice Rules <classical>

#highlight[...]

== A Statistics Of Social Choice // ============================================

=== Preference Realization <realization>

So far, the only conception of voting has been with _preferences_. But do voters actually submit their ballots deterministically? No. It's unrealistic to assume that voters always vote rationally in a predefined way. There is an element of randomness in the voting process. Say that a voter has the following opinions: $pi_1 = 65% "approval"$ and $pi_2 = 35% "approval"$. The voter may submit a ballot with $pi_1 prec pi_2$ or $pi_2 prec pi_1$ depending on how they feel on the day of the election. Voting is a _stochastic process_.

This conceptualization facilitates the need to disambiguate a _preference_ from a _ballot_.#footnote[Here I redefine preference to a new definition and define ballot in its place.] A preference is redefined as a distribution over preference orderings, and a ballot is a realization of that distribution. Think of a preference like a superposition, and when the election is held, the preference collapses into a ballot.

Stochastic voting is a concept hardwired into the framework of this thesis, as all the methods for generating ballots are stochastic. This framing allows us to conceptualize these _synthesizers_ as voters who non-deterministically submit their ballots via some set of rules. Granted those rules might be "randomly select an ordering of candidates", but it's still of the same process as real voting.

=== Statistical Social Choice Rules <statistical>

== Strategic Voting <strategic-voting> // ======================================

#highlight[...]
