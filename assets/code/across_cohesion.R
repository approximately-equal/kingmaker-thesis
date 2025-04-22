library(jsonlite)
library(tidyverse)

across_cohesion <- fromJSON("across_cohesion/across_cohesion.json", simplifyVector = FALSE)

across_cohesion <- map_dfr(across_cohesion, function(entry) {
  map_dfr(entry$outcomes, function(outcome) {
    tibble(
      tactic = entry$tactic,
      cohesion = entry$cohesion,
      weight = entry$weight,
      winners = paste(outcome$winners, collapse = ", "),
      times = outcome$times
    )
  })
})

across_cohesion <- across_cohesion %>%
  group_by(cohesion, tactic) %>%
  summarize(
    prop_A = sum(
      case_when(
        winners == "A" ~ times,
        str_detect(winners, "A") ~ 0.5 * times,
        .default = 0
      )
    ) / sum(times),
  )

across_cohesion$tactic <- factor(across_cohesion$tactic, c("identity", "burial", "compromise", "pushover"))

kingmaker_theme <- function() {
  maple_mono <- element_text(family = "Maple Mono", size = 8)
  theme_grey(base_family = "serif", base_size = 14) +
  theme(
    axis.title.x = element_text(margin = margin(t = 10)),
    axis.title.y = element_text(margin = margin(r = 10)),
    legend.position = "bottom",
    axis.text = maple_mono,
    strip.text = maple_mono,
    legend.title = maple_mono,
    legend.text = maple_mono
  )
}

plot <- across_cohesion %>%
  ggplot(aes(x = cohesion, y = prop_A, color = tactic, group = tactic)) +
    geom_line(
      stat = "identity",
      position=position_jitter(w=0.001, h=0.001),
      linewidth = 1.5
    ) +
    scale_x_continuous(limits = c(0.35, 0.60)) +
    scale_color_manual(values = c(
      "identity" = hex(HLS(220, 0.54, 0.91)),
      "burial" = hex(HLS(347, 0.44, 0.87)),
      "compromise" = hex(HLS(109, 0.40, 0.58)),
      "pushover" = hex(HLS(35, 0.49, 0.77))
    )) +
    labs(
      x = "Cohesion",
      y = "Proportion of Wins for Candidate A",
      color = "Tactic"
    ) +
    kingmaker_theme()

plot
