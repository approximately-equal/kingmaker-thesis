// chapter =====================================================================
= Results <results>
This chapter should begin by introducing (1) the metrics that quantify manipulability of a voting method, and (2) the methods for judging the efficacy of a strategy (under some set of social conditions).

This should follow on explanation about which social conditions and combinations of `method`, `strategy`, and `synthesizer` will be used.

== Optimization
This section should provide the results on "optimal" strategies for given `methods` or `social conditions`. This includes both simple known strategies and novel computational strategies (that we make). For each of these strategies, explain:
  1. What general class of strategy it is
  2. How it works conceptually
  3. How is is implemented, and what are the hyper-parameters

For results, provide tables that give various metrics across the battery of `methods` and `social conditions` that its trained and ran on.

== Method Analysis
This section should use the known + novel strategies to test the manipulability of various `methods`. The results should be from a range of (`synthesizer`, `social conditions`) pairs, and measured across each manipulability metric. Use ridge plots for this.

For analysis, ask (1) Which methods generally performed well or poorly---and what does that say about the metrics themselves, which ones should we put credence to---and (2) What were the strengths and weaknesses of each of the `methods`.
