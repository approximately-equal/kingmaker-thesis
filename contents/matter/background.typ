#import "../../template/packages/theorion.typ": *

= Background <background>

== A History of Social Choice <history> // =====================================

Social choice has been applied since humanity has existed. After all there has always been a need to make collective decisions. Its theory, however, is more modern, and tracks changes in our values and methodologies around collective action and voting.

=== Precursors <precursors>

Early social choice theory was far more concerned with voting as a procedure than of social welfare as an ideal.

One such precursor, Pliny the Younger---a Roman magistrate---wrote a letter to Titius Aristo on June 24, 105 describing the a criminal trail which he presided over. Under the traditional senate procedures, there would first be a vote of innocence / guilt, and then if guilty, or punishment, to which exile or execution were proposed. Of the three proposals, aquittal, exile, or execution, aquittal held the plurality of supporters, but not the majority, although exile would have won in a direct two-way vote against either aquittal or execution. Pliny expected that guilt would be asserted, and then execution. Being himself in favor or exile, he proposed a novel three-way election. This had the disired effect; supporters of execution withdrew their proposal (since aquittal would win if they split the vote for exile), and the vote defaulted to a two-way election between aquittal and exile, which exile carried.

Here we find one of the earliest recorded instances of voting manipulation. Pliny deliberately changed the voting rules so that execution would have split the vote between exile and execution, leading to acquittal. In response the voters changed strategies and voted for the second best option.

Other notable precursors include Catalan Ramon Lull (1232--1316) and the German Nikolaus von Kues (1401--1464). Ramon Lull produced, among other things, what is now known as Copeland (or Lull's) method, in which the winner is the candidate with the most pairwise wins against other candidates via ranked ballots. Von Kues is known for proposing what is now known as Borda's method, a method that we will discuss shortly.

=== The Math of Consensus <consensus>

Jean-Charles de Borda (1733--1799) and Nicolas de Condorcet (1743--1794) are considered the modern founders of social choice theory. They are distinguished from their precursors by the mathematical nature of their analysis.

Of the two, Borda's contributions are the more limited, having only written few pages. In that space he outlined the Borda count, a Condorcet method---which we'll discuss in just a moment---where the each candidate is assigned a score defined as the aggregate points assigned by their placement on each ballot. (With $k$ options, rank 1 gets $k-1$ points, rank 2 gets $k-2$, etc.) The candidates with the most points wins. In the same article, he also shows that the plurality method is flawed, given that it can select a pairwise loser to all other candidates (i.e. a Condorcet loser).

Condorcet alternatively devotes an entire books---along with several papers---worth of material on voting in his _Essay on the Application of Analysis to the Probability of Majority Decisions_ [translated from the native French]. In his work, Condorcet establishes many notable results, including Condorcet's jury theorem and Condorcet's paradox.

Condorcet's jury theorem proves that if each jury member is more likely than not to make a correct verdict, then the probability that the majority verdict is correct increases as the number of jury members increases.

Condorcet's paradox, a fundamental property of majority rule, states that with more than 2 candidates plurality methods can become intransitive (_not_ transitive)---it's possible for $A$ to pairwise beat $B$, $B$ to pairwise beat $C$, _and_ $C$ to pairwise beat $A$.

#highlight[Note Charles Dodgson (Lewis Carroll) here]

=== Welfare Economics <welfare-economics>

Thus far, we've seen discussion about particular voting systems and their properties, such as _Condorcet_ and _Borda_, but we have yet to introduce a general approach to the study of preference aggregation and social choice. This is where _Kenneth Arrow_ comes into the picture. It's Kenneth Arrow's nobel prize-worthy contributions that first formalized such a approach. Specifically, to studies a sub-class of preference aggregation methods that he called _social welfare functions_. He then proceeded to use this framework to prove the famous _Arrow's impossibility theorem_ @arrows-theorem (1963), which states that for more than 2 voters voting between 3 or more possible alternatives, there does not exist a social welfare function $cal(W)$ that satisfies a set of reasonable axioms---they are incompatible.

  - _Universal domain:_ $cal(W)$ can contain any possible complete and transitive preference ordering.
  - _Weak pareto efficiency:_ If every individual prefers $c_1$ to $c_2$, then the social preference should also prefer $c_1$ to $c_2$.
  - _Independence of irrelevant alternatives:_ If $cal(W)$ prefers $c_1$ to $c_2$ when $c_3$ is not present, then $cal(W)$ should also prefer $c_1$ to $c_2$ when $c_3$ is present.
  - _Non-dictatorship:_ No single individual should have the power to determine the social preference. #v(1em)

This theorem sparked much debate in social choice. As the _Stanford Encyclopedia of Philosophy_ notes, "William Riker (1920–1993), who inspired the Rochester school in political science, interpreted it as a mathematical proof of the impossibility of populist democracy (e.g., Riker 1982). Others, most prominently Amartya Sen (born 1933), who won the 1998 Nobel Memorial Prize, took it to show that ordinal preferences are insufficient for making satisfactory social choices and that social decisions require a richer informational basis. Commentators also questioned whether Arrow’s desiderata on an aggregation method are as innocuous as claimed or whether they should be relaxed."

But while Arrow's impossibility theorem might be _the_ social choice theorem, it's a different but no less important social choice theorem that will be the focus of our research today. That theorem being the _Gibbard-Satterthwaite theorem_ @gibbard-satterthwaite-theorem. The Gibbard-Satterthwaite theorem was first conjectured by philosopher Michael Dummett and the mathematician Robin Farquharson in 1961 and then independently proved by philosopher Allan Gibbard in 1973 and economist Mark Satterthwaite in 1975.

It states, broadly, that for any non-dictatorial, voting system with at least 3 alternatives, there does not exist for a voter aiming to maximize their own social welfare any _dominant strategy_, including the identity strategy---honest voting. This will be expounded upon in the following sections.

== Classic Social Choice <classic-social-choice> // ============================

At its core, social choice theory is concerned with the analysis of _preference aggregation_, understood to be the aggregation of individual preferences, each of which compares two or more social alternatives, into a single collective preference (or choice).

=== Basic Framework <framework>

Let $V = {v_i | i in {1..n}}$ be a set of $n$ voters ($n >= 2$) with preferences $Pi = {pi_i | i in {1..n}}$, and $C = {c_i | i in {1..m}}$ be a set of $m$ social alternatives (candidates). A _preference ordering_ is defined by a complete, total order on $C$ known as a _weak preference_. It is written with the symbol $prec.eq, succ.eq$, where $c_1 prec.eq c_2$ is defined as $c_1$ is preferred or indifferent to $c_2$. There are also shorthands for _strict preference_ ($c_1 prec c_2 := c_1 prec.eq c_2 and c_2 prec.eq.not c_1$) and _strict indifference_ ($c_1 ~ c_2 := c_1 prec.eq c_2 and c_2 prec.eq c_1$).

Having defined this, for the purposes of this analysis, we'll stick to the more specific social welfare function. The term social welfare function is a specific type of preference aggregation rule that _always_ produces a complete social ranking of alternatives.

A collection of preference orderings across a set of voters $V$, is called a _profile_, denoted $Pi = {pi_i | i in {1..n}}$. A _social welfare function_ is a function $cal(W): Pi -> ⟨c_i_1,...,c_i_m⟩$. It creates something know as a _complete social ordering_ which ranks each pair of alternatives ${c_i, c_j} in C$.

A full set of symbols can be found in @symbols-definitions

=== Strategic Voting <strategic-voting>

Having discussed some theory, let's revisit the all-important Gibbard-Satterthwaite theorem. Being more specific, it states that any collective decision-making process, at least one of the following must hold:

  + _dictatorial_, i.e. there exists some voter $v_i$ who decides the winner; or
  + _trivial_, i.e. there are only 2 possible winners; or
  + _manipulable_, i.e. there is no single always-best strategy for any particular voter (which does not depend on the preferences of other voters).

Note here that I'm condensing several proofs into one. In reality, the classic Gibbard-Satterthwaite proof applies only to deterministic, ordinal, single-winner elections. Gibbard's theorem then expanded the scope to cover processes of collective decision that may not be ordinal, such as cardinal voting. Gibbard's 1978 theorem and Hylland's theorem extend to non-deterministic processes, and Duggan–Schwartz theorem extends these results to multiwinner electoral systems.

This is a monumental result. It proves that no matter the voting system, there is always incentive for voters to manipulate the outcome. Strategic voting is inevitable so long as voters aim to maximize their utility. The question is, how much utility can be gained by strategic voting, and which voting systems are most susceptible to manipulation?

=== Historical Voting Methods

There are many historical and current voting methods that are used across the world. Let's look at some of the most common ones:

#definition(title: "Plurality")[
  Plurality is an ordinal-adjacent, single-winner voting method, also known as first-past-the-post (FPTP).

  Let $C$ be a set of candidates, and $Pi$ a profile of ballots. Each candidate $c$ has a score $S$, defined as the number of first-place votes they receive. $
    S := |{pi in Pi | pi[0] = c}|.
  $

  The candidate with the most first place votes wins.
]

Note that while plurality is sometimes called majority voting, a candidate does not need to have a majority of the votes to win. Consider an election where $(A: 250, B: 200, C: 150)$. The total number of votes is $250 + 200 + 150 = 600$. $A$ wins because they have the most votes, but they didn't have a majority.

#definition(title: "Borda")[
  Borda (count) is a ordinal, single-winner voting method.

  Let $C$ be a set of candidates, and $Pi$ a profile of ballots. Each candidate $c$ has a score $S$, defined as the cumulative sum of their rankings in each ballot. $
    S := sum_(pi in Pi) sum_(i = 1)^(|pi|) i dot I(pi[i] = c).
  $ where $I$ is the indicator function. In other words, the candidate with the highest cumulative ranking wins.
]

#example[
  Suppose there are three candidates $A$, $B$, and $C$, and a voter ranks them as $A prec B prec C$. Then $A$ gets 2 points, $B$ gets 1 point, and $C$ gets 0 points.
]

#definition(title: "Approval")[
  Approval (voting) is a nominal, single-winner voting method.

  Let $C$ be a set of candidates, and $Pi$ a profile of ballots. Each candidate $c$ has a score $S$ defined as the number of voters who approve of them. $
    S := |{pi in Pi | c in pi}|
  $

  The candidate with the most approvals wins.
]

#example[
  Suppose there are three candidates $A$, $B$, and $C$; A voter approves of $A$ and $B$. Then $A$ and $B$ each get 1 point, and $C$ gets 0 points.
]

#definition(title: "IRV")[
  Instant Runoff Voting (IRV) is a ordinal, single-winner voting method.

  Let $C$ be a set of candidates, and $Pi$ a profile of ballots. IRV occurs in rounds, which continue until one candidate has a majority of the votes. In each round, the candidate(s) with the fewest first-place votes is eliminated, and their votes are redistributed to the remaining candidates based on the voters' second choices.
]

#example[
  Suppose we have 4000 ballots with preferences $A prec B prec C prec D$, 3500 ballots with preferences $B prec D prec A prec C$, 1500 ballots with preferences $C prec A prec B prec D$, 1000 ballots with preferences $D prec C prec B prec A$.

  + Round 1: Counting the first place votes, $A = 4000, B = 3500, C = 1500, D = 1000$. No candidate has a majority, so we elimimate the last place candidate, which is $D$, we now re-distribute the votes for $D$ to the next candidate. In this case that is $C$.

  + Round 2: Counting the first place votes, $A = 4000, B = 3500, C = 2500$. No candidate has a majority, so we eliminate the last place candidate, which is $C$, we now re-distribute the votes for $C$ to the next candidate. In this case that is $A$.

  + Round 3: Counting the first place votes, $A = 6500, B = 3500$. Candidate $A$ has a majority, so we declare $A$ the winner.
]

#definition(title: "STV")[
  Single Transferable Vote (STV) is a ordinal, multi-winner voting method.

  Let $C$ be a set of candidates, $Pi$ a profile of ballots, and $k$ the number of seats to elect. In order to determine when a candadite can be elected, a quota is used, typically the droop quota, which is $
    (|Pi|) / (k + 1)
  $

  STV occurs in rounds, which continue until all seats are filled. In each round, one of two things can happen:

  - A candidate exceeds the quota, and is elected. Then their votes are redistributed to the next candidate in the voter's ranking.

  - No candidate exceeds the droop quota, and the candidate(s) with the fewest votes is eliminated. Their votes are redistributed to the next candidate in the voter's ranking.
]

== Statistical Social Choice <statistical-social-choice> // ====================

So far, we've applied the classical philosophical and economic framework of social choice theory. This framework presupposes that preferences are the static immovable opinions of a voter. While this is fine as a framework, its categorically unrealistic. In reality, voters do not have static preferences, nor do they know precisely who they will vote for with absolute certainty. They may have a preference for one candidate over another, but they may also be influenced by external factors such as the media, their friends, or their own emotions. Say that a voter has the following opinions: $c_1 = 65% "approval"$ and $c_2 = 35% "approval"$. The voter may submit a ballot with $c_1 prec c_2$ or $c_2 prec c_1$ depending on how they feel on the day of the election. Voting is a _stochastic process_. This reality is not captured by classical theory. We need something more, we need a statistical approach to social choice.

=== Preference Realization <realization>

A preference thus far has been deterministic, but now we want to modify it to align with the stochastic nature of voting. How do we do that? Well, let's just make it a probability distribution. Instead of preferences being a preference ordering, define preferences to be a distribution over preference orderings. For each preference ordering there is associated some probability of being realized. This probability is determined by the voter's preferences and the external factors that influence their decision. The realization of a preference is called a _ballot_.

For notation, we'll use $Pi$ to denote a profile of ballots, and $cal(P)(v_i, theta)$ to denote the preferences of voter $v_i$ given the external factors $theta$.

This form of stochastic voting is a concept hardwired into the framework of this thesis, as all the methods for generating ballots are stochastic. This framing allows us to conceptualize these models as voters who non-deterministically submit their ballots via some set of rules. Granted those rules might be "randomly select an ordering of candidates", but it's still of the same process as real voting.

=== Statistical Social Choice Rules <statistical>

The idea of preference realization comes up in social choice theory, though they define it as a model for ballot generation, rather than a stochastic realization. These models have characteristics and parameters $theta$ which allow us to simulate voting behavior in some ways. Below a few of the most common models are defined.

#definition(title: "Impartial")[
  Let $Pi$ be the collection of possible ballots. The impartial model randomly draws votes according to the following pmf. $
    P[pi] = 1 / (|Pi|)
  $
]

In other words, the Impartial preference model samples from a uniform distribution over possible ballots.

#definition(title: "Manual")[
  Let $Pi_0$ be the collection of ballots submitted in some real election. The manual model randomly samples a subset of this collection without replacement. Therefore, the pmf of drawing a profile $pi$ with $|pi| = n$ is $
    P[pi] = 1 / binom(|Pi_0|, n)
  $
]

#example[
  Consider a toy example where the ballots are $A prec B prec C, B prec C prec A, C prec A prec B$. To sample a profile with $2$ ballots, say ballots 1 and 3 are selected. Then the profile contains $A prec B prec C, C prec A prec B$.
]

#definition(title: "Plackett-Luce")[
  Let $theta = [w_1, w_2, ...]$ a collection of weights associated to each candidate, and $C$ the set of candidates. The Plackett-Luce model randomly draws votes according to the following pmf $
    P[pi] = product_(r = 1)^(R) w_(pi[r]) / (sum_(s in C) w_s - sum_(t in {pi_0, ..., pi_(r-1)}) w_t)
  $ where $R$ is the number of ranked candidates in the ballot.
]

The Plackett-Luce model constructs a ballot sequentially. At each step, a candidate is chosen randomly, with probability proportional to their current weight, and then removed from consideration. The remaining weights are re-normalized, and the process repeats until all candidates are ranked.

#example[
  Consider a case where the weights are $[0.5, 0.3, 0.2]$:

  + _First draw_: Say candidate 1 is selected (they had a 50% chance of being selected). Then the ballot is now $[1, ...]$ and the weights are $(0.3, 0.2) => (0.6, 0.4)$.

  + _Second draw_: Say candidate 2 is selected (they had a 60% chance of being selected). Then the ballot is now $[1, 2, ...]$ and the weights are $(0.2) => (1.0)$.

  + _Third draw_: Say candidate 3 is selected (they had a 100% chance of being selected). Then the ballot is now $[1, 2, 3]$. This completes the ballot generation.
]

#definition(title: "Mallows")[
  Let $pi_0$ be the central ranking of the candidates (e.g. $A prec B prec C$), and $phi.alt in [0, oo)$ be the cohesion parameters. Additionally set a distance function $d$ that measures the distance between two rankings $pi$ and $pi_0$. Typically this distance function is the Kendall Tau distance, which counts the number of pairwise disagreements between two rankings. The Mallows model randomly draws votes according to the following pmf $
    P[pi] prop exp(-phi.alt dot d(pi, pi_0))
  $

  There is a known partition function $Z(phi.alt)$ to normalize the pmf.
]

While this pmf is well-defined, it doesn't tell us how to actually draw a ranking from it. Implementation-wise, drawing occurs by first sampling a distance, and then uniformly drawing a ranking from the set of rankings at that distance.

The pmf of drawing a ranking with distance $l$ is given by $exp(-phi.alt dot d(pi, pi_0)) dot "# of ballots with distance" l$. The number of ballots with distance $l$ is---given that $d$ is the kendall tau distance---equivalent to the number of permutations of $n$ elements with exactly $l$ inversions. This number is given by the Mahonian distribution, which is the distribution of the number of inversions in a random permutation.

With a distance $l$ drawn, uniformly draw a ranking from the set of rankings with distance $l$. This is done---again given that $d$ is the kendall tau distance---in the following way [written as python pseudocode]:

#figure(caption: [Sample a uniform decomposition vector])[
  ```python
  def sample_decomposotion_vector(n, k, rng):
      decomposition = []
      inv_left = k

      while inv_left > 0:
          slots_left = n - i - 1

          max_ahead_inv = (slots_left * (slots_left - 1) // 2
          min_inv = min(inv_left - max_ahead_inv, 0)
          max_inv = min(slots_left, inv_left)

          inv = rng.uniform_int(min_inv, max_inv)
          decomposition.append(inv)
          inv_left = inv_left - inv

      return decomposition
  ```
]

The decomposition vector can then be easily converted to a ranking with the following algorithm [written as python pseudocode]:

#figure(caption: [Convert a decomposition vector to a ranking])[
  ```python
  def decomposition_to_ranking(v):
      # Unsorted indices of available candidates
      available = [0, ..., len(v)]
      # Initialize the permuted indices with empty vec of size |v|
      perm = [None] * len(v)

      # For each index in the decomposition vector
      for i, sigma_i in enumerate(v):
          # Remove the "inv #" sigma_i from available candidates
          push = available.pop(sigma_i)
          # Push the removed candidate to the permutation vector
          perm[i] = push

      # Return the complete permutation
      return perm
  ```
]

By following this process, it is possible to sample a specific ranking from the Mallows model.
