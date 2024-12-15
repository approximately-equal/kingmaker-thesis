#import "@preview/ctheorems:1.1.3": *

#let hl-red    = rgb("#ea9999")
#let hl-orange = rgb("#f9cb9c")
#let hl-yellow = rgb("#ffe599")
#let hl-green  = rgb("#b6d7a8")
#let hl-blue   = rgb("#a4c2f4")
#let hl-purple = rgb("#b4a7d6")

#let theorem = thmbox("theorem", "Theorem", fill: hl-green)
#let lemma = thmbox("theorem", "Lemma")
#let corollary = thmbox(
  "corollary",
  "Corollary",
  base: "theorem",
  base_level: 1
).with(numbering: "1.1")
#let proof = thmproof("proof", "Proof").with(numbering: none)
#let example = thmbox("example", "Example").with(numbering: none)
#let definition = thmbox("definition", "Definition", fill: hl-red)
#let exercise = thmplain("exercise", "Exercise")
