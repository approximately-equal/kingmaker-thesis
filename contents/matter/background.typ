#import "../../template/lib.typ": theorion
#import theorion: *

= Background <background>

To understand the dynamics of strategic voting, we must first establish a formal foundation in social choice theory. This background section introduces the key concepts and terminology that underpin the rest of the analysis. It also outlines major results in voting theory---such as the Gibbard–Satterthwaite theorem and Arrows impossibility theorem---that highlight the fundamental limits of election design. In addition, we survey common strategic tactics (such as compromise and burial), models of voter preferences (such as the Impartial and Mallows models), and widely studied voting methods (such as Plurality and IRV). By grounding the discussion in this formal framework, we aim to provide the tools necessary to interpret the behavior of strategic agents in electoral settings.

== A History of Social Choice <history>

Social choice has been applied since humanity has existed. After all there has always been a need to make collective decisions. Its theory, however, is more modern, and tracks changes in our values and methodologies around collective action and voting.

=== Precursors <precursors>

Early social choice theory was far more concerned with voting as a procedure than of social welfare as an ideal.

One such precursor, Pliny the Younger---a Roman magistrate---wrote a letter to Titius Aristo on June 24, 105 @mclean-1995-classics, describing the a criminal trial which he presided over. Under the traditional senate procedures, there would first be a vote of innocence or guilt, and then if guilty, vote on a punishment, either exile or execution. Of the three proposals, acquittal, exile, or execution, acquittal held the plurality of supporters, but not the majority, although exile would have won in a direct two-way vote against either acquittal or execution. Pliny expected that guilt would won, and then execution. Being in favor of exile, he proposed a novel three-way election. This had the desired effect; supporters of execution withdrew their proposal, as acquittal would win if they split the vote for exile. The vote defaulted to a two-way election between acquittal and exile, which exile won.

This is one of the earliest recorded instances of voting manipulation. Pliny deliberately changed the voting rules so that execution would have split the vote between exile and execution, leading to acquittal. In response the voters changed strategies and voted for the second best option.

Other notable precursors include Catalan Ramon Lull (1232--1316) and the German Nikolaus Von Kues (1401--1464). Ramon Lull produced, among other things, what is now known as Copeland (or Lull's) method, in which the winner is the candidate with the most pairwise wins against other candidates via ranked ballots @copeland1951reasonable. Von Kues is known for proposing what is now known as Borda's method @hägele2008cusa.

=== The Math of Consensus <consensus>

Jean-Charles de Borda (1733--1799) and Nicolas de Condorcet (1743--1794) are considered the modern founders of social choice theory. They are distinguished from their precursors by the mathematical nature of their analysis.

Of the two, Borda's contributions are the more limited, having only written few pages. In that space he outlined the Borda count, a Condorcet method where the each candidate is assigned a score defined as the aggregate points assigned by their placement on each ballot. (With $k$ options, rank 1 gets $k-1$ points, rank 2 gets $k-2$, etc.) The candidates with the most points wins. In the same article, he also shows that the plurality method is flawed, given that it can select a pairwise loser to all other candidates (i.e. a Condorcet loser).

Condorcet alternatively devotes an entire books---along with several papers---worth of material on voting in his _Essay on the Application of Analysis to the Probability of Majority Decisions_ [translated from the native French]. In his work, Condorcet establishes many notable results, including Condorcet's jury theorem and Condorcet's paradox. Condorcet's jury theorem proves that if each jury member is more likely than not to make a correct verdict, then the probability that the majority verdict is correct increases as the number of jury members increases. Condorcet's paradox, a fundamental property of majority rule, states that with more than 2 candidates plurality methods can become intransitive (_not_ transitive)---it's possible for $A$ to pairwise beat $B$, $B$ to pairwise beat $C$, _and_ $C$ to pairwise beat $A$.

It bears mentioning that Condorcet's jury paradox relates to Condorcet methods, a class of voting systems that are named after him. Condorcet methods are voting methods that elect the candidate who wins head-to-head elections against every other candidate, whenever such a candidate exists. When such a candidate does not exist, the method is said to be _intransitive_---it exhibits Condorcet's paradox.

=== Welfare Economics <welfare-economics>

Up until the mid-twentieth century, social choice theory had been primarily focused on the study of voting systems and their properties, such as _Condorcet_ and _Borda_. A general approach to the study of preference aggregation and social choice has not yet been developed. This is where _Kenneth Arrow_ came into the picture. It's Kenneth Arrow's Nobel prize-worthy contributions that first formalized such an approach, formally classifying a sub-class of preference aggregation methods that he called _social welfare functions_. He then proceeded to use this framework to prove the famous _Arrow's impossibility theorem_ @arrows-theorem in 1963.

#theorem(title: "Arrow's Impossibility Theorem")[
  For a collection of 2 or more voters choosing between 3 or more possible alternatives, there does not exist a social welfare function $cal(W)$ that satisfies a set of reasonable axioms---they are incompatible.

  - _Universal domain:_ $cal(W)$ can contain any possible complete and transitive preference ordering.
  - _Weak pareto efficiency:_ If every individual prefers $c_1$ to $c_2$, then the social preference should also prefer $c_1$ to $c_2$.
  - _Independence of irrelevant alternatives:_ If $cal(W)$ prefers $c_1$ to $c_2$ when $c_3$ is not present, then $cal(W)$ should also prefer $c_1$ to $c_2$ when $c_3$ is present.
  - _Non-dictatorship:_ No single individual should have the power to determine the social preference.
]

This theorem sparked much debate in social choice. As the _Stanford Encyclopedia of Philosophy_ notes,

#quote(block: true)[
  William Riker (1920–1993), who inspired the Rochester school in political science, interpreted it as a mathematical proof of the impossibility of populist democracy (e.g., Riker 1982). Others, most prominently Amartya Sen (born 1933), who won the 1998 Nobel Memorial Prize, took it to show that ordinal preferences are insufficient for making satisfactory social choices and that social decisions require a richer informational basis. Commentators also questioned whether Arrow’s desiderata on an aggregation method are as innocuous as claimed or whether they should be relaxed.
]

But while Arrow's impossibility theorem might be the most well-known social choice theorem, it's a different but no less important social choice theorem that will be the focus of our research today. That theorem being the _Gibbard-Satterthwaite theorem_ @gibbard-satterthwaite-theorem. The Gibbard-Satterthwaite theorem was first conjectured by philosopher Michael Dummett and the mathematician Robin Farquharson in 1961 @gibbard-satterthwaite-conjecture and then independently proved by philosopher Allan Gibbard in 1973 @gibbard-satterthwaite-gibbard and economist Mark Satterthwaite in 1975 @gibbard-satterthwaite-satterthwaite. Gibbard's proof is more general, considering not only ordinal elections, but cardinal voting. Gibbard's 1978 theorem @gibbard-satterthwaite-non-deterministic and Hylland's theorem expand the set of processes to encompass non-deterministic processes . The Duggan–Schwartz theorem extends these results to multiwinner elections @duggan-2000.

It states, broadly, that for any non-dictatorial, voting system with at least 3 alternatives, there does not exist for a _dominant strategy_ for any voter aiming to maximize their own social welfare, including the identity strategy (honest voting). For a more formal statement of the theorem, see @gibbard-satterthwaite-def.

== Classic Social Choice <classic-social-choice> // ============================

At its core, social choice theory is concerned with the analysis of _preference aggregation_, understood to be the aggregation of individual preferences, each of which compares two or more social alternatives, into a single collective preference (or choice). This occurs by the following fundamental framework.

=== Basic Framework <framework>

Let $V = {v_i | i in {1,...,n}}$ be a set of $n$ voters ($n >= 2$) with preferences $Pi = {pi_i | i in {1,...,n}}$, and $C = {c_i | i in {1,...,m}}$ be a set of $m$ social alternatives (candidates). A _preference ordering_ is defined by a complete, total order on $C$ known as a _weak preference_. It is written with the symbol $prec.eq$, where $c_1 prec.eq c_2$ is defined as $c_1$ is preferred or indifferent to $c_2$. There are also shorthands for _strict preference_ ($c_1 prec c_2 := c_1 prec.eq c_2 and c_2 prec.eq.not c_1$) and _strict indifference_ ($c_1 ~ c_2 := c_1 prec.eq c_2 and c_2 prec.eq c_1$).

Having defined the concept of preference ordering, for the purposes of this analysis, we'll stick to the more specific social welfare function. The term social welfare function is a specific type of preference aggregation rule that _always_ produces a complete social ranking of alternatives.

A collection of preference orderings across a set of voters $V$, is called a _profile_, denoted $Pi = {pi_i | i in {1..n}}$. A _social welfare function_ is a function $cal(W): Pi -> ⟨c_i_1,...,c_i_m⟩$. It creates something know as a _complete social ordering_ which ranks each pair of alternatives ${c_i, c_j} in C$.

A full set of symbols can be found in @symbols-definitions.

=== Strategic Voting <strategic-voting>

Having established some theory, our attention turns to strategic voting. Naturally, we begin with the all-important Gibbard-Satterthwaite theorem.

#theorem(title: "Gibbard-Satterthwaite")[
  For any (reasonable) collective decision-making process, at least one of the following must hold:

    + _dictatorial_, i.e. there exists some voter $v_i$ who decides the winner; or
    + _trivial_, i.e. there are only 2 possible winners; or
    + _manipulable_, i.e. no voter has a _dominant strategy_---the strategy that maximizing social welfare depends on how others vote.
] <gibbard-satterthwaite-def>

As discussed previously, the classical Gibbard–Satterthwaite theorem pertains specifically to deterministic, ordinal, single-winner voting rules. The statement here condenses a sequence of foundational results into a unified definition. While each subsequent proof expanded the class of procedures which follow this rule, they share a common implication: under broad conditions, strategic manipulation is unavoidable.

This is a monumental result. It proves that no matter the voting system, there is always incentive for voters to manipulate the outcome. Strategic voting is inevitable so long as voters aim to maximize their utility. The question is, how much utility can be gained by strategic voting, and which voting systems are most susceptible to manipulation? In order to answer that, it is necessary to establish a set of common voting methods.

=== Common Tactics <common-tactics>

On a more practical note, there are a few commonly observed tactics that voters implement. These include identity, compromise, burial, and pushover, all of which are defined below.

#definition(title: "Identity")[
  With honest preferences $pi$, identity is defined by $
    pi |-> pi
  $
]

Compromise is a tactic on ordinal ballots, which will move compromise candidate(s) (typically the second-most-preferred candidate) to first place, because they have a higher chance to win.

#definition(title: "Compromise")[
  Let ${c_1, ..., c_n} = C$ be a set of candidates, $pi$ a honest preference, and $⟨k⟩$ an ordered set of comprise candidates. Compromise is defined by $
    (⟨c_(pi[1]), ..., k, ..., c_(pi[n])⟩, ⟨k⟩) |-> k plus.double (⟨c_(pi[1]), ..., c_(pi[n])⟩ without ⟨k⟩)
  $ where $without$ denotes list subtraction (preserving order) and $plus.double$ denotes list concatenation.
]

#example[
  Let $pi = ⟨A, B, C, D⟩, k = ⟨B, C⟩$. Then $"Compromise"(pi, k) = ⟨B, C, A, D⟩$
]

Burial is a tactic on ordinal ballots, which will move opposition candidate(s) to last place, burying them in the rankings and minimizing their chances of winning against other more preferred candidates.

#definition(title: "Burial")[
  Let ${c_1, ..., c_n} = C$ be a set of candidates, $pi$ a honest preference, and $k$ an ordered set of burial candidates. Burial is defined by $
    (⟨c_(pi[1]), ..., c_(pi[n])⟩, k) |-> (⟨c_(pi[1]), ..., c_(pi[n])⟩ without k) plus.double k
  $ where $without$ denotes list subtraction (preserving order) and $plus.double$ denotes list concatenation.
]

#example[
  Let $pi = ⟨A, B, C, D⟩, k = ⟨C, B⟩$. Then $"Burial"(pi, k) = ⟨A, D, C, B⟩$
]

Pushover is a tactic on ordinal ballots, which typically is employed in multi-round elections. The idea is to put pushover candidates in a better position, hoping that they will eliminate or prevent opposition candidates from winning, but will later be "pushed over" by the true preferred candidates.

#definition(title: "Pushover")[
  Let ${c_1, ..., c_n} = C$ be a set of candidates, $pi$ a honest preference, $k$ an ordered set of preferred candidates, and $l$ an ordered set of pushover candidates. Pushover is defined by$
    (⟨c_(pi[1]), ..., c_(pi[n])⟩, k) |-> k plus.double l plus.double (⟨c_(pi[1]), ..., c_(pi[n])⟩ without (k union l))
  $ where $without$ denotes list subtraction (preserving order), $plus.double$ denotes list concatenation, and $union$ denotes list union.
]

#example[
  Let $pi = ⟨A, B, C, D, E, F⟩, k = ⟨A, B⟩, l = ⟨E, F⟩$. Then $"Burial"(pi, k) = ⟨A, B, E, F, C, D⟩$
]

=== Historical Voting Methods

Along with tactics, there are many historical and current voting methods that are used across the world. Voting methods can be broken down by which type of ballots they use. The three most common are: ordinal, cardinal, and norminal. Ordinal ballots are rankings, (e.g. $⟨A, B, C⟩$). Cardinal ballots are scores, (e.g. $A = 3, B = 4, C = 2$. Nominal ballots are sets, ${A, B}$. Below are a few of the most common ones.

#definition(title: "Plurality")[
  Plurality is an ordinal-adjacent, single-winner voting method, also known as first-past-the-post (FPTP).

  Let $C$ be a set of candidates, and $Pi$ a profile of ballots. Each candidate $c$ has a score $S$, defined as the number of first-place votes they receive. $
    S := |{pi in Pi | pi[0] = c}|.
  $

  The candidate with the most first place votes wins.
]

Note that while plurality is sometimes called majority voting, a candidate does not need to have a majority of the votes to win. Consider an election where $(A: 250, B: 200, C: 150)$. The total number of votes is $250 + 200 + 150 = 600$. $A$ wins because they have the most votes, but they didn't have a majority.

#definition(title: "Borda")[
  Borda (count) is an ordinal, single-winner voting method.

  Let $C$ be a set of candidates, and $Pi$ a profile of ballots. Each candidate $c$ has a score $S$, defined as the cumulative sum of their rankings in each ballot. $
    S := sum_(pi in Pi) sum_(i = 1)^(|pi|) (|pi| - i) dot I(pi[i] = c).
  $ where $I$ is the indicator function. The candidate with the highest score $S$ wins.
]

#example[
  Suppose there are three candidates $A$, $B$, and $C$, and a voter ranks them as $A prec B prec C$. Then $A$ gets 2 points, $B$ gets 1 point, and $C$ gets 0 points.
]

#definition(title: "Approval")[
  Approval voting is a nominal, single-winner voting method.

  Let $C$ be a set of candidates, and $Pi$ a profile of ballots. Each candidate $c$ has a score $S$ defined as the number of voters who approve of them. $
    S := |{pi in Pi | c in pi}|
  $

  The candidate with the most approvals wins.
]

#example[
  Suppose there are three candidates $A$, $B$, and $C$; A voter approves of $A$ and $B$. Then $A$ and $B$ each get 1 point, and $C$ gets 0 points.
]

#definition(title: "IRV")[
  Instant Runoff Voting (IRV) is an ordinal, single-winner voting method.

  Let $C$ be a set of candidates, and $Pi$ a profile of ballots. IRV occurs in rounds, which continue until one candidate has a majority of the votes. In each round:
  - If any candidate has a majority of the votes, they win.
  - If no candidate has a majority of the votes, the candidate(s) with the fewest first-place votes is eliminated; their votes are then redistributed to the remaining candidates based on the voters' next choice, if any.
]

#example[
  Suppose we have 4000 ballots with preferences $A prec B prec C prec D$, 3500 ballots with preferences $B prec D prec A prec C$, 1500 ballots with preferences $C prec A prec B prec D$, 1000 ballots with preferences $D prec C prec B prec A$ (10,000 total ballots).

  + Round 1: Counting the first place votes, $A = 4000, B = 3500, C = 1500, D = 1000$. No candidate has a majority, so the last place candidate ($D$) is eliminated. Their votes are redistributed to the next candidate ($C$).

  + Round 2: Counting the first place votes, $A = 4000, B = 3500, C = 2500$. No candidate has a majority, so the last place candidate ($C$) is eliminated. Their votes are redistributed to the next candidate ($A$).

  + Round 3: Counting the first place votes, $A = 6500, B = 3500$. Candidate $A$ has a majority, so $A$ is the winner.
]

#definition(title: "STV")[
  Single Transferable Vote (STV) is an ordinal, multi-winner voting method.

  Let $C$ be a set of candidates, $Pi$ a profile of ballots, and $k$ the number of seats to elect. In order to determine when a candidate can be elected, a quota is used, typically the so-called Droop quota, $
    (|Pi|) / (k + 1)
  $

  STV occurs in rounds, which continue until all seats are filled. In each round, one of two things can happen:

  - If a candidate exceeds the quota, they are elected. Their excess votes are then redistributed to the next candidate in the voter's ranking. This redistribution is proportional: each ballot contributing to the surplus is transferred at a fractional weight such that the total transferred equals the surplus.

  - If no candidate exceeds the droop quota, then the candidate(s) with the fewest votes are eliminated. Their votes are then redistributed to the next candidate in the voter's ranking, if any.
]

#example[
  Suppose we want to elect $2$ seats. There are 4,500 ballots with preferences $A prec C prec B prec D$, 3000 ballots with preferences $B prec D prec A prec C$, 1500 ballots with preferences $C prec A prec B prec D$, 1000 ballots with preferences $D prec C prec B prec A$ (10,000 total ballots). Thus the droop quota is $10000 / (2 + 1) = 3333$.

  + Round 1: Counting the first place votes, $A = 4500, B = 3000, C = 1500, D = 1000$. Candidate $A$ exceeds the quota, and is elected. Their votes are redistributed to the next candidate ($C$).

  + Round 2: Counting the first place votes, $C = 4500 + 1500 = 6000, B = 3000, D = 1000$. Candidate $C$ exceeds the quota, and is elected. There are no more seats to fill, so the election is over. Candidates $A$ and $C$ are elected.
]

== Statistical Social Choice <statistical-social-choice> // ====================

Up to this point, the analysis has operated within the classical philosophical and economic framework of social choice theory, which presumes that voter preferences are fixed and immutable. While this is fine as a framework, it's categorically unrealistic. In reality, voters do not have static preferences, nor do they know precisely who they will vote for with absolute certainty. They may have a preference for one candidate over another, but they may also be influenced by external factors such as the media, their friends, or their own emotions. Say that a voter has the following opinions: $c_1 = 65% "approval"$ and $c_2 = 35% "approval"$. The voter may submit a ballot with $c_1 prec c_2$ or $c_2 prec c_1$ depending on how they feel on the day of the election. Voting is a _stochastic process_. This reality is not captured by classical theory. We need something more: a statistical approach to social choice.

=== Preference Realization <realization>

Thus far, preferences have been treated as deterministic. However, to better align with the stochastic nature of voting, we now aim to modify this framework. The solution is simple: define preferences as _distributions_ over ballots. Instead of preferences being a preference ordering, define preferences to be a distribution over preference orderings. For each preference ordering there is associated some probability of being realized. This probability is determined by the voter's preferences and the external factors that influence their decision. The realization of a preference is called a _ballot_.

For notation, we'll use $Pi$ to denote a profile of ballots, and $cal(P)(v_i, theta)$ to denote the preferences of voter $v_i$ given the population-level parameters $theta$.

This form of stochastic voting is a concept hardwired into the framework of this thesis, as all the methods for generating ballots are stochastic. This framing allows us to conceptualize these models as voters who non-deterministically submit their ballots via some set of rules. Granted, those rules might be "randomly select an ordering of candidates", but it's still of the same process as real voting.

=== Statistical Social Choice Rules <statistical>

The idea of preference realization comes up in social choice theory, though social choice theorists (aka economists) define it as a model for ballot generation, rather than a stochastic realization (e.g. @guide-numerical). These models have characteristics and parameters $theta$ which allow us to simulate voting behavior in some ways. Below a few of the most common models are defined.

#definition(title: "Impartial")[
  Let $Pi$ be the collection of possible ballots. The impartial model randomly realizes some ballot $pi$ with probability according to: $
    P[pi] = 1 / (|Pi|)
  $
]

In other words, the Impartial preference model samples from a uniform distribution over possible ballots.

#definition(title: "Manual")[
  Let $Pi_0$ be the collection of ballots submitted in some real election. The manual model randomly samples a subset of this collection without replacement. Thus the manual model randomly realizes some _profile_ (not ballot) $pi$ with probability according to: $
    P[pi] = 1 / binom(|Pi_0|, |pi|)
  $
]

#example[
  Consider a toy example where the ballots are $A prec B prec C, B prec C prec A, C prec A prec B$. To sample a profile with $2$ ballots, say ballots 1 and 3 are selected. Then the profile contains $A prec B prec C, C prec A prec B$.
]

#definition(title: "Plackett-Luce")[
  Let $theta = [w_1, w_2, ..., w_(|C|)]$ a collection of weights associated to each candidate, and $C$ the set of candidates. The Plackett-Luce model randomly realizes some ballot $pi$ with probability according to: $
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
  Let $pi_0$ be the central ranking of the candidates (e.g. $A prec B prec C$), and $phi.alt in [0, oo)$ be the cohesion parameter. Additionally set a distance function $d$ that measures the distance between two rankings $pi$ and $pi_0$. Typically this distance function is the Kendall Tau distance, which counts the number of pairwise disagreements between two rankings.

  The Mallows model randomly realizes some ballot $pi$ with probability according to: $
    P[pi] prop exp(-phi.alt dot d(pi, pi_0))
  $

  There is a known partition function $Z(phi.alt)$ to normalize the pmf.
]

While this pmf is well-defined, it doesn't tell us how to actually draw a ranking from it. Implementation-wise, drawing occurs by first sampling a distance, and then uniformly drawing a ranking from the set of rankings at that distance. Assuming that the distance function $d$ is the Kendall Tau distance, the following approach is sufficient to realize a ballot.

The pmf of drawing a ranking with distance $k$ is given by: $
  exp(-phi.alt dot d(pi, pi_0)) dot "# of ballots with distance" k.
$ The number of ballots with distance $k$ is equivalent to the number of permutations (rankings) of $n$ elements with exactly $k$ inversions. This number is given by the Mahonian distribution, which is the distribution of the number of inversions in a random permutation.

Second, with a distance $k$ drawn, uniformly draw a ranking from the set of rankings with distance $k$. This is done by constructing a decomposition vector where the number at a given index $i$ corresponds to the number of inversions---numbers bigger than $i$ but which are before $i$ in the permutation. The following is the commented algorithm [written as python pseudocode]:

#figure(caption: [Sample a uniform decomposition vector])[
  ```Python
  def sample_decomposotion_vector(n, k, rng):
      decomposition = []
      inv_left = k

      while inv_left > 0:
          # Number of remaining slots that can have inversions
          slots_left = n - i - 1

          # The # of remaining inversions possible supposing that
          # this position has 0 inversions
          max_ahead_inv = (slots_left * (slots_left - 1) // 2
          # Minimum possible inversions at this index
          min_inv = min(inv_left - max_ahead_inv, 0)
          # Maximum possible inversions at this index
          max_inv = min(slots_left, inv_left)

          # Uniformly sample an inversion
          inv = rng.uniform_int(min_inv, max_inv)
          decomposition.append(inv) # Add `inv` to decomp. vector
          inv_left = inv_left - inv # Update remaining inversions

      return decomposition
  ```
]

The decomposition vector can then be easily converted to a ranking with the following algorithm [written as python pseudocode]:

#figure(caption: [Convert a decomposition vector to a ranking])[
  ```Python
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

By following the above process, it is possible to randomly sample a ranking from the Mallows model.
