# Visualizations and final regression (updated: filter realrinc > 0 and plot log(avg_income))

# Source the data-prep script which creates `gss_final`
source("analysis/dataprep.R")

# For analyses that require positive income, filter realrinc > 0
gss_final_pos <- gss_final %>%
  filter(realrinc > 0)

library(ggplot2)

# Visualization 1: Self-employment and happiness (uses full sample)
gss_final_visuals <- gss_final %>%
  group_by(self_employed) %>%
  summarize(prob_happy = mean(is_very_happy), .groups = "drop")

p1 <- ggplot(data = gss_final_visuals, aes(x = factor(self_employed), y = prob_happy, fill = factor(self_employed))) +
  geom_col() +
  scale_fill_brewer(palette = "Dark2", labels = c("Someone Else", "Self-Employed")) +
  theme_bw() +
  labs(
    title = "Self Employment and Happiness",
    x = "Self Employed",
    y = "Probability of Being Very Happy",
    fill = "Employment"
  )

print(p1)

# Visualization 2: Hours worked and probability of being very happy by sex (uses full sample)
gss_final_visuals1 <- gss_final %>%
  group_by(hrs1, sex) %>%
  summarize(prob_happy = mean(is_very_happy), .groups = "drop")

p2 <- ggplot(data = gss_final_visuals1, aes(x = hrs1, y = prob_happy, color = sex)) +
  geom_point() +
  geom_smooth(se = FALSE) +
  scale_color_brewer(palette = "Dark2", labels = c("male", "female")) +
  theme_bw() +
  labs(
    title = "Hours Worked and Probability of Being Very Happy",
    x = "Hours Worked per Week",
    y = "Probability of Being Very Happy",
    color = "Gender"
  )

print(p2)

# Visualization 3: Income and probability of being very happy, by self-employment
# Use observations with realrinc > 0 and plot log(avg_income)
gss_visuals_2 <- gss_final_pos %>%
  mutate(income_bin = cut(realrinc, breaks = 50)) %>%
  group_by(income_bin, self_employed) %>%
  summarize(
    avg_income = mean(realrinc, na.rm = TRUE),
    prob_happy = mean(is_very_happy, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  # remove any bins with NA avg_income (shouldn't be necessary after filter)
  filter(!is.na(avg_income))

p3 <- ggplot(gss_visuals_2, aes(x = log(avg_income), y = prob_happy, color = factor(self_employed))) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  scale_color_brewer(palette = "Dark2", labels = c("Someone Else", "Self-Employed")) +
  theme_bw() +
  labs(
    title = "Log(Average Income) and Probability of Being Very Happy",
    x = "Log(Average Income)",
    y = "Probability of Being Very Happy",
    color = "Employment"
  )

print(p3)

# Save plots to analysis/ folder
ggsave("analysis/self_employed_happiness.png", p1, width = 6, height = 4)
ggsave("analysis/hrs1_by_sex_happiness.png", p2, width = 7, height = 5)
ggsave("analysis/income_happiness_by_employment_logavg.png", p3, width = 7, height = 5)

# Final regression model using observations with positive income
# using log(realrinc) is now safe because we filtered realrinc > 0
model_final <- lm(is_very_happy ~ self_employed + hrs1 * sex_female + log(realrinc) +
                    age + I(age^2) + race + educ, data = gss_final_pos)

# Print model summary and save model object
print(summary(model_final))
saveRDS(model_final, file = "analysis/model_final.rds")
