= Results <results>

== Across Cohesion

Starting with a simple demo, consider what happens when only one voting bloc has a strategy (that isn't identity).

The election setup has 3 candidates: A (DEM), B (REP), and C (IND), with method instant runoff (IRV). There are 2 voting blocs: 5,000 Democrats and 5,000 Republicans. Each bloc has a characteristic preference order, modeled using the Mallows distribution. Democrats are centered around the ranking [A, C, B] with cohesion parameter $phi.alt$, while Republicans follow [B, C, A] with cohesion $1 - phi.alt$. Only Democrats have a strategy, which they use 10% of the time, the other 90% of the time using the identity strategy. @across-cohesion shows the results of running this configuration.

#figure(caption: [Proportion of wins for candidate A across cohesion for each strategy])[
  #image("../../assets/across_cohesion.svg")
] <across-cohesion>

The identity tactic has a 50-50 chance of A winning when the $phi.alt = 1-phi.alt = 0.5$, which is what we expect. With the cohesion parameters equal, the two voting blocs create ballots in exactly symmetric ways, making the winner a even split between A and B. In this setup, C never wins at any cohesion level.

Looking at the actual strategies, they do in fact work, giving Democrats an edge even with lower cohesion levels. Given that the proportion of wins is 50% at $phi.alt approx 0.45$, we can interpret these strategies as making up for a 5% weaker cohesion (with respect to the Mallows model).

Also consider that these strategies all have the _same_ effect. In fact the effect is _exactly_ the same, because the rng is seeded and deterministic. The slight difference is just added jitter for improved legibility.

This fact makes sense only because the election is so simple, and would not hold up in more complex scenarios. Speaking of...

== Across Tactics

A natural question that arises from this analysis is: _Which tactics perform best when deployed against one another?_ To explore this, the following experimental setup is applied.

We consider an election with four candidates: A (DEM), B (REP), C (GREEN), and D (IND). The election will be tabulated via instant-runoff (IRV). The electorate consists of two equally sized voting blocs: 5,000 Democrats and 5,000 Republicans. Each bloc has a characteristic preference order, modeled using the Mallows distribution. Democrats are centered around the ranking [A, C, D, B] with cohesion parameter $phi.alt$, while Republicans follow [B, C, D, A] with cohesion $1 - phi.alt$.

Each voter uses a strategy 10% of the time, and defaults to the identity strategy the remaining 90%. We vary the strategy employed by each bloc in order to evaluate tactical interactions.

@across-tactic presents the outcomes of these matchups. The columns represent the strategy used by Democrats, and the rows represent those used by Republicans.

#figure(caption: [Proportion of wins for each candidate across all combinations of tactics])[
  #image("../../assets/across_tactic.svg")
] <across-tactic>

Several patterns emerge from this pairwise matchup of strategies. Firstly, note the 4 quadrants. Turns out that in this scenario identity and burial have nearly identical effects, the same for compromise and pushover. Let's discuss each of these quadrants in turn.

*Identity and Burial*: Let’s begin with the quadrant where both blocs use either identity or burial. Both strategies have a similar effect: they do nothing to elevate the bloc’s preferred candidate, but instead either do nothing or attempt to hurt the opposition. As a result, neither bloc improves its own chances, and the compromise candidate C---who is ranked second by both blocs---is often the one who benefits most and wins the election.

Interestingly, the chances of candidates A or B (the blocs’ "true" candidates) winning increases slightly when both blocs have similar cohesion values. Recall that in the Mallows model, cohesion $phi.alt = 0$ means fully random preferences (equivalent to impartial), while $phi.alt -> oo$ corresponds to completely fixed preferences (everyone votes the central preference).

Suppose Democrats have low cohesion (strong preference coherence), and Republicans have high cohesion (weaker coherence). In this case, Democrats’ ballots frequently rank A first and C second, but Republicans will vote C first more often, hurting the chances of A winning. Thus while A might be first more often, the Republicans will bury A so it has few second or third place votes. Candidate C does not have this problem, with many second place votes from Democrats and some first place votes from Republicans. Thus candidate C is likely to win.

*Compromise and Pushover*: Turning to the quadrant where both blocs use compromise or pushover, the resulting plot looks nearly identical to the one in @across-cohesion under the identity strategy. This tells us that these two strategies effectively cancel each other out in this context. But unlike identity and burial, these strategies are constructive rather than destructive---they aim to promote the bloc’s own candidate rather than harm the opponent. As a result, candidate C---who is not being elevated---never wins.

A somewhat surprising finding is that compromise performs just as well as pushover, despite pushover being a more aggressive strategy. In the pushover strategy, a Democrat, for instance, always submits [A, C, D, B] regardless of their underlying preferences. This suggests that in this context, the only meaningful impact comes from placing the bloc’s preferred candidate at the top---the rest of the ranking has little influence on the outcome.

*Compromise and Pushover vs Identity and Burial*: Moving to the top-right, we'll find yet another surprising result: the weaker strategies (identity and burial) do better when they have a high $phi.alt$ than the stronger strategies (compromise and pushover) do. This seems counterintuitive, but the explanation lies in how these strategies interact with cohesion.

When a bloc uses a weak strategy with high $phi.alt$, then they will rank candidate C first or second often. The opposing block, with lower $phi.alt$ will place candidate C higher more often, and its strategy will keep C in first place, as described previously. Thus the compromise candidate tends to win. This is not the case the other way around, thus the weaker strategies can end up winning over candidate C, while the stronger strategies fail.

Now let’s return to the plot and its structure.

While the top-left and bottom-right quadrants of the figure may look different at first glance, they actually represent identical strategic behavior. This symmetry arises because the roles of Democrats and Republicans are mirror images: swapping one for the other produces the same outcome, just with the candidate labels reversed. In other words, the strategic dynamics are the same, even though the players have switched sides. #highlight[this part is incomplete because I don't fully understand it]

So why do the plots look different? It’s simply a matter of orientation. The strategy combinations have been flipped across the diagonal, but the direction of $phi.alt$ has not. As a result, candidates A and B remain in the same positions, while wins by candidate C appear mirrored across the vertical axis. This visual shift creates the illusion of different outcomes, when in fact the underlying dynamics are symmetric. #highlight[this needs to be explained more clearly]

*Takeaway*: This plot highlights how strategic interactions can produce outcomes that are both unintuitive and surprisingly complex. Even in a simple, symmetric setup, the interplay between voting blocs can lead to results that run counter to each bloc’s intent.

For instance, Democrats using the pushover strategy might hope to help candidate C defeat the Republican candidate (B) only to inadvertently hand the win to C instead of their own candidate (A). In hindsight, perhaps pushing a less competitive candidate like D would have been more effective.

These kinds of unexpected dynamics will appear throughout the analysis, underscoring how strategic voting often has ripple effects that are difficult to predict in isolation.

== Across Method

Another natural question is: _How does the choice of voting method change the dynamics of strategy?_ In order to test it, scenario similar---but distinct---to @across-tactic is used. The candidates are still A (DEM), B (REP), C (GREEN), and D (IND). There are still two equally-sized voting blocs, but they only have 4,500 members each, because a third voting bloc has been added. This voting block is the Independent bloc, which has a size of 1,000 members, and has central preference $D prec C prec A, B$, with cohesion 0.2. This bloc always votes honestly.

The strategy weight is still $0.1$ for non-identity strategies. This time, the cohesion parameter for the Democrats and Republicans are independently set, each $[0.4, 0.45, 0.5, 0.55, 0.6]$. The left labels are the tactics used by the Democrats and Republicans respectively. The rightmost label is Democrates, the leftmost for Republicans.

#figure(caption: [Proportion of wins for candidate A across methods and tactics])[
  #image("../../assets/across_method_A.svg")
] <across-method-A>

#figure(caption: [Proportion of wins for candidate B across methods and tactics])[
  #image("../../assets/across_method_B.svg")
] <across-method-B>

#figure(caption: [Proportion of wins for candidate C across methods and tactics])[
  #image("../../assets/across_method_C.svg")
] <across-method-C>

Let's take a closer look at the results of @across-method-A. Turn first to Random Dictator, this serves as a baseline. As expected, its nearly regardless of strategy, since there is only a 10% chance of actually selecting a strategic ballot in the first place. We can see a slight gradient as the cohesion of bloc A increases, which is due to the increased likelihood that a random ballot will be closer to the central ballot, thus having $A$ first.

Looking over to Borda, turns out $A$ never wins. Turns out that with Borda count, candidate $C$'s strong position with nearly every voter ensures a victory 100% of the time, regardless of the cohesion of either bloc.

The interesting behavior is really in plurality and IRV. In plurality, we see a massive differece between times when $A$ uses destructive strategies vs constructive ones. In destructive strategies (identity and burial), $A$ never wins, conceding mostly to $C$, but occasionally to $B$ when $B$ uses a constructive strategy. When $A$ uses constructive strategies, $A$ wins much more often, and concedes to $B$ when $B$ has higher cohesion. Notice that while $A$ wins more of the time with #highlight[...More needs to be added here]
