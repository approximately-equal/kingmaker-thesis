library(jsonlite)
library(tidyverse)
library(stringr)
library(showtext)
library(ggthemes)

font_add("Maple Mono", "[...]/MapleMono-Regular.ttf")
font_add("Crimson Pro", regular = "[...]/CrimsonPro[wght].ttf", bold = "[...]/CrimsonPro[wght].ttf")
showtext_auto()

across_tactic <- fromJSON("across_tactic/across_tactic.json", simplifyVector = FALSE)

across_tactic <- map_dfr(across_tactic, function(entry) {
  map_dfr(entry$outcomes, function(outcome) {
    tibble(
      tactic_A = entry$tactic_A,
      tactic_B = entry$tactic_B,
      cohesion = entry$cohesion,
      weight = entry$weight,
      winners = paste(outcome$winners, collapse = ", "),
      times = outcome$times
    )
  })
})

across_tactic <- across_tactic %>%
  group_by(cohesion, tactic_A, tactic_B) %>%
  summarize(
    prop_A = sum(
      case_when(
        winners == "A" ~ times,
        str_detect(winners, "A") ~ 0.5 * times,
        .default = 0
      )
    ) / sum(times),
    prop_B = sum(
      case_when(
        winners == "B" ~ times,
        str_detect(winners, "B") ~ 0.5 * times,
        .default = 0
      )
    ) / sum(times),
    prop_C = sum(
      case_when(
        winners == "C" ~ times,
        str_detect(winners, "C") ~ 0.5 * times,
        .default = 0
      )
    ) / sum(times),
    prop_D = sum(
      case_when(
        winners == "D" ~ times,
        str_detect(winners, "D") ~ 0.5 * times,
        .default = 0
      )
    ) / sum(times)
  )

across_tactic <- across_tactic %>%
  pivot_longer(
    cols = starts_with("prop_"),
    names_to = "candidate",
    values_to = "proportion"
  ) %>%
  mutate(candidate = str_remove(candidate, "prop_"))

across_tactic$tactic_A <- factor(across_tactic$tactic_A, levels = c("identity", "burial", "compromise", "pushover"))
across_tactic$tactic_B <- factor(across_tactic$tactic_B, levels = c("identity", "burial", "compromise", "pushover"))

kingmaker_theme <- function() {
  maple_mono <- element_text(family = "Maple Mono", size = 8)
  theme_grey(base_family = "serif", base_size = 14) +
  theme(
    axis.title.x = element_text(margin = margin(t = 10)),
    axis.title.y = element_text(margin = margin(r = 10)),
    axis.text.x = element_text(angle = 30, hjust = 0.75, vjust = 0.75),
    legend.position = "bottom",
    panel.grid = element_blank(),
    axis.text = maple_mono,
    strip.text = maple_mono,
    legend.title = maple_mono,
    legend.text = maple_mono
  )
}

plot <- across_tactic %>%
  ggplot(aes(x = cohesion, y = proportion, fill = candidate)) +
    geom_bar(stat = "identity") +
    facet_grid(cols = vars(tactic_A), rows = vars(tactic_B)) +
    scale_x_continuous(breaks = scales::breaks_pretty(n = 5)) +
    scale_y_continuous(breaks = scales::breaks_pretty(n = 3)) +
    labs(
      x = "Cohesion (for Democrats)",
      y = "Proportion of Elections Won",
      fill = "Candidate"
    ) +
    scale_fill_manual(values = c(
      "A" = hex(HLS(220, 0.54, 0.91)),
      "B" = hex(HLS(347, 0.44, 0.87)),
      "C" = hex(HLS(109, 0.40, 0.58)),
      "D" = hex(HLS(35, 0.49, 0.77))
    )) +
    kingmaker_theme()

plot
