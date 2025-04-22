library(jsonlite)
library(tidyverse)
library(stringr)
library(colorspace)

across_method <- fromJSON("across_method/across_method.json", simplifyVector = FALSE)

across_method <- map_dfr(across_method, function(entry) {
  map_dfr(entry$outcomes, function(outcome) {
    tibble(
      tactic_A = entry$tactic_A,
      tactic_B = entry$tactic_B,
      cohesion_A = entry$cohesion_A,
      cohesion_B = entry$cohesion_B,
      weight = entry$weight,
      method = entry$method,
      winners = paste(outcome$winners, collapse = ", "),
      times = outcome$times
    )
  })
})

across_method <- across_method %>%
  group_by(cohesion_A, cohesion_B, tactic_A, tactic_B, method) %>%
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
    ) / sum(times),
    .groups = "drop"
  )

across_method <- across_method %>%
  pivot_longer(
    cols = starts_with("prop_"),
    names_to = "candidate",
    values_to = "proportion"
  ) %>%
  mutate(candidate = str_remove(candidate, "prop_"))

across_method$tactic_A <- factor(
  across_method$tactic_A,
  levels = c("identity", "burial", "compromise", "pushover")
)
across_method$tactic_B <- factor(
  across_method$tactic_B,
  levels = c("identity", "burial", "compromise", "pushover")
)
across_method$method <- factor(
  across_method$method,
  levels = c("Rng Dict.", "Borda", "Plurality", "IRV")
)

kingmaker_theme <- function() {
  maple_mono <- element_text(family = "Maple Mono", size = 8)
  theme_grey(base_family = "serif", base_size = 14) +
  theme(
    axis.title.x = element_text(margin = margin(t = 10)),
    axis.title.y = element_text(margin = margin(r = 10)),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
    panel.grid = element_blank(),
    axis.text = maple_mono,
    strip.text = maple_mono,
    legend.title = maple_mono,
    legend.text = maple_mono
  )
}

plot_across_method <- function(df, color) {
  ggplot(df, aes(x = cohesion_A, y = cohesion_B, fill = proportion)) +
    geom_tile() +
    coord_fixed() +
    facet_grid(rows = vars(method), cols = vars(tactic_A, tactic_B)) +
    scale_fill_gradient(low="#f7f6f3",high=hex(color)) +
    labs(
      x = "Cohesion of Bloc A",
      y = "Cohesion of Bloc B",
      fill = "Prop"
    ) +
    kingmaker_theme()
}

plot_A <- plot_across_method(
  across_method %>% filter(candidate == "A"),
  HLS(220, 0.54, 0.91)
)
plot_B <- plot_across_method(
  across_method %>% filter(candidate == "B"),
  HLS(347, 0.44, 0.87)
)
plot_C <- plot_across_method(
  across_method %>% filter(candidate == "C"),
  HLS(109, 0.40, 0.58)
)
plot_D <- plot_across_method(
  across_method %>% filter(candidate == "D"),
  HLS(35, 0.49, 0.77)
)

plot_A
plot_B
plot_C
plot_D
