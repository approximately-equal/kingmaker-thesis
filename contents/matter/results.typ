= Results <chp:results>

Recall that we wish to explore how strategic voting impacts election outcomes depending on the method, the social conditions (preference models and relative frequencies of voters in each voting bloc), and strategy. With the necessary background and methodology covered, we proceed to actually using `kingmaker` to simulate elections and see what results we obtain.

== Across Cohesion

Starting with a simple demo, consider what happens when only one voting bloc has a strategy (that isn't identity).

The election setup has 3 candidates: A (DEM), B (REP), and C (IND), with method instant runoff (IRV). There are 2 voting blocs: 5,000 Democrats and 5,000 Republicans. Each bloc has a characteristic preference order, modeled using the Mallows distribution. Democrats are centered around the ranking $A prec C prec B$ with cohesion parameter $phi.alt$, while Republicans follow $B prec C prec A$ with cohesion $1 - phi.alt$. Only Democrats have a strategy, which they use 10% of the time, the other 90% of the time using the identity strategy. @fig:across-cohesion shows the results of running this configuration.

#figure(caption: [
  Proportion of wins for candidate $A$ across cohesion for each strategy. The burial, compromise, and pushover strategies are all the same (overlapping).
])[
  #image("../../assets/across_cohesion.svg")
] <fig:across-cohesion>

The identity tactic has a 50--50 chance of $A$ winning when the $phi.alt = 1-phi.alt = 0.5$, which is what we expect. With the cohesion parameters equal, the two voting blocs create ballots in exactly symmetric ways, making the winner an even split between $A$ and $B$. In this setup, $C$ never wins at any cohesion level.

Looking at the actual strategies, they do in fact work, giving Democrats an edge even with lower cohesion: the proportion of wins is 50% at $phi.alt approx 0.45$. Also consider that these strategies all have the _same_ effect. In fact the effect is _exactly_ the same, because the randomness (RNG) is seeded and deterministic. The slight difference is just added jitter for improved legibility. This fact makes sense only because the election is so simple, and would not hold up in more complex scenarios.

== Across Tactics

A natural question that arises from this analysis is: _Which tactics perform best when deployed against one another?_ To explore this, the following experimental setup is applied.

We consider an election with four candidates: $A$ (DEM), $B$ (REP), $C$ (GREEN), and $D$ (IND). The election will be tabulated via instant-runoff (IRV). The electorate consists of two equally sized voting blocs: 5,000 Democrats and 5,000 Republicans. Each bloc has a characteristic preference order, modeled using the Mallows distribution. Democrats are centered around the ranking $A prec C prec D prec B$ with cohesion parameter $phi.alt$, while Republicans follow $B prec C prec D prec A$ with cohesion $1 - phi.alt$. Each voter uses a strategy 10% of the time, and defaults to the identity strategy the remaining 90%. We vary the strategy employed by each bloc in order to evaluate tactical interactions.

The Mallows model will produce a ranking with some number of inversions for each ballot, depending on the number of candidates $n$ and the cohesion parameter $phi.alt$. We use $n = 4$, giving a distribution as shown.

#figure(caption: [Distribution of inversions for $n = 4$])[
  #table(
    columns: 8,
    table.header([$phi.alt$], [0 Inv], [1 Inv], [2 Inv], [3 Inv], [4 Inv], [5 Inv], [6 Inv]),
    [$0.00$], [$4.17%$], [$12.50%$], [$20.83%$], [$25.00%$], [$20.83%$], [$12.50%$], [$4.17%$],
    [$0.25$], [$8.25%$], [$19.27%$], [$25.01%$], [$23.37%$], [$15.17%$], [$7.09%$], [$1.84%$],
    [$0.50$], [$14.35%$], [$26.10%$], [$26.39%$], [$19.21%$], [$9.71%$], [$3.53%$], [$0.71%$],
    [$0.75$], [$22.24%$], [$31.52%$], [$24.82%$], [$14.07%$], [$5.54%$], [$1.57%$], [$0.25%$],
    [$1.00$], [$31.32%$], [$34.56%$], [$21.19%$], [$9.35%$], [$2.87%$], [$0.63%$], [$0.08%$],


  )
]

@fig:across-tactics presents the outcomes of these matchups. The columns represent the strategy used by Democrats, and the rows represent those used by Republicans. Several patterns emerge from this pairwise matchup of strategies. The plot naturally divides into four quadrants, each representing different combinations of bloc strategies. Interestingly, identity and burial behave similarly, as do compromise and pushover.

#figure(caption: [
  Proportion of wins for each candidate across all combinations of tactics. The columns represent the strategy used by Democrats, and the rows represent those used by Republicans. Each color corresponds to a different candidate, with the x-axis the cohesion ($phi.alt$) of the Democrats ($1 - phi.alt$ for Republicans), and the y-axis the proportion of election wins (or ties) under the given conditions.
])[
  #image("../../assets/across_tactic.svg")
] <fig:across-tactics>

This similarity is best understood through the distinction between _constructive_ and _non-constructive_ tactics.

- Non-constructive tactics---like identity and burial---do not promote the bloc’s preferred candidate. Instead, they aim to harm opposing candidates or simply express honest preferences without strategic elevation.

- Constructive tactics—like compromise and pushover—actively promote the bloc’s preferred candidate, often by ranking them first or manipulating the ballot to increase their chances of winning.

As it turns out, this constructive vs. non-constructive divide accounts for most of the observed variation in electoral outcomes, at least for elections between two voting blocs. If that’s the main axis of difference, then we should expect only three substantially distinct types of strategic interactions:

+ Non-constructive vs. non-constructive
+	Constructive vs. constructive
+ Constructive vs. non-constructive

The presence of four quadrants, however, appears to suggest an additional category. Upon closer inspection, this discrepancy is resolved by noting that the top-right and bottom-left quadrants both represent scenarios in which one bloc employs a constructive strategy while the other adopts a non-constructive one. The apparent difference arises solely from the reversal of roles between the two blocs. While the strategies are inverted, the cohesion parameters remain fixed---the left corresponding to strong Republican cohesion and the right with strong Democratic cohesion. This means that Democrats still win more when $phi.alt$ is high (and Republicans when $phi.alt$ is low), but candidate C wins when $phi.alt$ is low, instead of high. The strategic dynamics are symmetric, and the shift in outcomes (e.g., the victory of the compromise candidate) reflects a reversal in bloc roles rather than a fundamental change in strategic interaction.

With this theoretical framework in place, it is now appropriate to examine each combination of strategies in detail, beginning with the case in which both blocs employ non-constructive tactics.

=== Non-constructive vs. Non-constructive Elections

In cases where both blocs use non-constructive tactics, the compromise candidate $C$ ends up dominating the election, winning over 90% of all elections regardless of cohesion. There is a noticeable---and counterintuitive ---increase in wins for $A$ and $B$ when the cohesion for each bloc is balanced. To understand this, we examine a balanced and non-balanced case.

Suppose without loss of generality that Democrats have high cohesion and Republicans have low cohesion. Both blocs vote honestly. Republican voters are more likely to rank $C$ first, undermining $B$’s chances. Meanwhile, Democrats rank $A$ first and $C$ second, unintentionally boosting $C$. Thus, attacks on the opposition can inadvertently strengthen a neutral candidate. Most elections go as follows: $A$ doesn't have a majority, $B$ is eliminated, their votes go primarily to $C$, and $C$ wins.

Suppose instead that Democrats and Republicans have equal cohesion, and vote honestly. It's possible that $A$ or $B$ simply score a majority right out the gate and win, without running a second round. This happens by getting first place votes from the opposition.

=== Constructive vs. Non-constructive Elections

In constructive vs non-constructive elections, we find yet another counterintuitive result: weaker strategies (identity and burial) do better when they have a high $phi.alt$ than the stronger strategies (compromise and pushover) do. This occurs because the asymmetry again benefits the compromise candidate when the constructive strategy has strong cohesion.

When a bloc uses a weak strategy with high $phi.alt$, then they will rank candidate $C$ first or second often. The opposing bloc, with lower $phi.alt$ will place candidate $C$ higher more often, and its strategy will keep C in first place, as described previously. Thus the compromise candidate tends to win. This is not the case the other way around, thus the weaker strategies can end up winning over candidate $C$, while the stronger strategies fail.

=== Constructive vs Constructive Elections

The most reasonable set of elections, the resulting plot looks nearly identical to the one in @fig:across-cohesion under the identity strategy. This tells us that these two strategies effectively cancel each other out in this context. Additionally, since these tactics are constructive, candidate $C$---who is not being elevated---never wins.

=== Considerations on Ballot Types

Thus far, we've taken for granted that identity and burial have the same effect, as do compromise and pushover. It bears saying that this is not obvious, and hints that in two-party elections, the only thing that matters is where you place the preferred candidate, and where you place the compromise candidate.

- Identity and burial don't push the preferred candidate.
- Compromise and pushover push the preferred candidate to first.

These are the only attributes that matter. This is not always the case.

_Takeaway_: This plot highlights how strategic interactions can produce outcomes that are both unintuitive and surprisingly complex. Even in a simple, symmetric setup, the interplay between voting blocs can lead to results that run counter to each bloc’s intent.

For instance, Democrats using the pushover strategy might hope to help candidate $C$ defeat the Republican candidate ($B$) only to inadvertently hand the win to $C$ instead of their own candidate ($A$). In hindsight, perhaps pushing a less competitive candidate like $D$ would have been more effective.

These kinds of unexpected dynamics will appear throughout the analysis, underscoring how strategic voting often has ripple effects that are difficult to predict in isolation.

== Across Methods

Another natural question is: _How does the choice of voting method change the dynamics of strategy?_ In order to test it, a scenario similar---but distinct---to @fig:across-tactics is used. The candidates are still $A$ (DEM), $B$ (REP), $C$ (GREEN), and $D$ (IND). There are still two equally-sized voting blocs, but they only have 4,500 members each, because a third voting bloc has been added. This voting bloc is the Independent bloc, which has a size of 1,000 members, and has central preference $D prec C prec A prec B$, with $phi.alt = 0.2$. This bloc always votes honestly.

The strategy weight is still $0.1$ for non-identity strategies. This time, the cohesion parameter for the Democrats and Republicans are independently set, each $[0.4, 0.45, 0.5, 0.55, 0.6]$. The left labels are the tactics used by the Democrats and Republicans respectively. The rightmost label is Democrats, the leftmost for Republicans.

#figure(caption: [
  Proportion of wins (or ties) for candidate $A$ across methods (Random dictator, Borda, Plurality, and IRV) and strategies (Identity, Burial, Compromise, Pushover), for given cohesion parameters for Democrats (x-axis) and Republicans (y-axis).
])[
  #image("../../assets/across_method_A.svg")
] <fig:across-method-A>

#figure(caption: [
  Proportion of wins (or ties) for candidate $B$ across methods (Random dictator, Borda, Plurality, and IRV) and strategies (Identity, Burial, Compromise, Pushover), for given cohesion parameters for Democrats (x-axis) and Republicans (y-axis).
])[
  #image("../../assets/across_method_B.svg")
] <fig:across-method-B>

#figure(caption: [
  Proportion of wins (or ties) for candidate $C$ across methods (Random dictator, Borda, Plurality, and IRV) and strategies (Identity, Burial, Compromise, Pushover), for given cohesion parameters for Democrats (x-axis) and Republicans (y-axis).
])[
  #image("../../assets/across_method_C.svg")
] <fig:across-method-C>

// #figure(caption: [
//   Proportion of wins (or ties) for candidate $D$ across methods (Random dictator, Borda, Plurality, and IRV) and strategies (Identity, Burial, Compromise, Pushover), for given cohesion parameters for Democrats (x-axis) and Republicans (y-axis).
// ])[
//   #image("../../assets/across_method_D.svg")
// ] <fig:across-method-D>

Let's take a closer look at the results of @fig:across-method-A. Turn first to Random Dictator which serves as a baseline. As expected, it's nearly regardless of strategy, since there is only a 10% chance of actually selecting a strategic ballot in the first place. We can see a slight gradient as the cohesion of bloc $A$ increases, which is due to the increased likelihood that a random ballot will be closer to the central ballot, thus having $A$ first.

With Borda, $A$ never wins. With Borda count, candidate $C$'s strong position with nearly every voter ensures a victory 100% of the time, regardless of the cohesion of either bloc.

The most notable patterns emerge under the Plurality and Instant-Runoff Voting (IRV) systems. In the case of Plurality, there is a pronounced divergence in outcomes depending on whether candidate $A$’s bloc adopts constructive or non-constructive strategies. When non-constructive strategies such as identity or burial are employed, candidate $A$ almost never wins. Instead, the election is typically conceded to candidate $C$, and occasionally to candidate $B$ when $B$’s bloc pursues a constructive tactic. In contrast, when $A$’s bloc employs constructive strategies such as compromise or pushover, the likelihood of an A victory increases substantially. In these cases, $B$ tends to prevail only when its bloc exhibits significantly higher cohesion.

It is also worth highlighting the combination of pushover (by one bloc) and burial (by the other), which results in a markedly higher win rate for candidate $C$. This effect is especially pronounced under IRV, but it is also observable under Plurality.

Notably, candidate A fails to secure any victories when both blocs employ non-constructive strategies. In such scenarios, the compromise candidate ($C$) consistently emerges as the winner. However, when candidate $A$’s bloc uses the identity strategy against a constructive strategy employed by the opposing bloc, $A$ can occasionally prevail---particularly when both blocs exhibit high levels of cohesion. In less cohesive settings, the advantage again shifts toward candidate $C$, who benefits from receiving broad, albeit secondary, support.

== Benchmarks

Each simulation, each 10,000 voters, running 1,000 times, took $approx 0.25 "seconds"$. @fig:across-method-A, @fig:across-method-B, @fig:across-method-C required running $4 times 4 times 4 times 5 times 5 = 1600$ simulations. The entire computation took $approx 7 "minutes"$
