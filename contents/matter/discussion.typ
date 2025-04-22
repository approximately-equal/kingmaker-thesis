= Discussion <discussion>

== Review <review>

Across all the configurations, strategies, methods, conditions, we find that strategic voting is both impactful and complex. It's hard for a voter or a bloc to know that a strategy will benefit them when considering the way that other blocks will vote. The results often end up being counterintuitive. The complexity of strategic voting is further compounded by the fact that it is often difficult to predict how other blocks will vote, and the impact of a strategy can vary depending on the specific configuration of the election. What works in some cases will not work in others.

We also find the recurring difference between _constructive_ and _destructive_ voting strategies. Constructive voting strategies aim to artificially inflate the voting bloc's core candidate(s), which destructive strategies aim to artificially deflate the opposition's core candidate(s). Naturally there are strategies that are a mix of both, which we call _hybrid_ strategies. These include pushover strategies, which both improve the ranking of the bloc's core candidate(s) and simultaneously harm the opposition's core candidate(s). In this vein, a interesting result is that identity behaves in a similar way to a destructive strategy, most likely because of how it doesn't hurt the compromise candidate like a constructive strategy would.

The results also underscore the "fingerprint" of various election methods. Some, like Borda, strongly favor the compromise candidate, while others, like plurality, favor the most popular candidate (by definition). Others like IRV promote more complex dynamics, which on one hand makes strategic voting more impactful, and on the other disincentivizes it, as its more difficult to game the system predictably.

== Introspection & Conclusion <conclusion>

Building `kingmaker` is an exercise in voting theory and methodology. How do voters vote? How should that process be effectively modeled? All these questions are necessary to construct a realistic model of voting, and thus strategic voting. As a realistic model of voting, `kingmaker` certainly falls short. However, that doesn't mean there isn't aspects that are fascinating. For instance, the model of preferences and their conversion to ballots is particularly notable. The idea of grouping voters by voting blocs is also a fundamental aspect of voting that should be explored further. However, it should expand up the naive method given in this paper, allowing for voters to be members of multiple blocs and have the interactions between these two influences have some covariant effect upon the voter.

More broadly, this work reinforces the importance of simulation in social choice research. Theoretical results like Gibbard–Satterthwaite tell us that strategy is inevitable, but they don’t tell us how strategy actually plays out. Simulation offers a way to bridge this gap. It lets us ask: What kinds of strategies are most impactful? Under what conditions do they backfire? Which methods incentivize bluffing, and which punish it? My hope is that this work contributes a small step in answering these questions—not just for scholars, but for designers of democratic systems who want to understand the trade-offs involved.

Ultimately, strategic voting is messy. It occupies the space between theory and practice, between structure and unpredictability. Two truths stand out from this research. First, every voting method lies on a spectrum between simplicity of strategy and vulnerability to manipulation. Plurality and Borda allow for intuitive tactics precisely because they are easy to exploit; systems like IRV, on the other hand, demand complex and context-dependent strategies that resist simple gaming. There is no "perfect" system—only different balances between accessibility and resilience.

Second, successful strategic voting depends on being well-informed. Even the most promising tactic can backfire without a clear understanding of the broader electoral environment. The composition of the blocs, the tactics they employ, and the design of the method itself all interact in unpredictable ways. Without knowledge, strategy becomes guesswork---and guesswork can lose elections. This is not just a theoretical concern: it’s a practical reminder that collective decision-making lives and dies on information and insight. To vote strategically is to engage with complexity, and to ignore that complexity is to risk undermining the very goals we seek to achieve.

== Future Research <future-research>

=== Optimal Strategies

One of the goals of this research, which unfortunately had to be cut due to time constraints, is to synthesize an _optimal_ strategy for a given understanding of the social conditions around an election. Future research could use `kingmaker` to simulate different strategies and compare their performance. There are many ways to go about this, including: Nash equilibrium, genetic algorithms, neural networks, and reinforcement learning.

=== Additional Configurations

And of course, even with my existing framework there are tons of simulation scenarios that could be explored. For example, we could simulate different levels of voter turnout, by changing the number of members. There is also a lot of work that could be done to simulate different types of candidates. In most of the configurations that were explored, there was an equal but opposing set of parties and a smaller compromise candidate or two. There are other configurations of candidates that could be explored, such as:

- One compromise candidate that is aligned with the majority party, and one that is aligned with the minority party, and how all four voting blocs interact with each other under different strategies.

- Inclusive parties and exclusionary parties, and how much of a difference does it make for voting blocs to be more inclusive or exclusive, depending on their respective sizes and the overall voter behavior.

- ...more.
