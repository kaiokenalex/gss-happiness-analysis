# Employment, Income, and Happiness: A GSS Regression Analysis

An econometric investigation of how employment type, hours worked, and income relate to self-reported happiness, using General Social Survey (GSS) data.

## Research Question

How does happiness — measured as a nonmonetary, self-reported outcome — respond to work-related characteristics? Specifically: does being self-employed, working more hours, or earning more income predict a higher probability of reporting being "very happy"?

## Data

- **Source:** General Social Survey, accessed via the [`gssr`](https://kjhealy.github.io/gssr/) R package
- **Sample:** 34,341 observations after cleaning, spanning survey years 1974–2024
- **Dependent variable:** `happy` (very happy / pretty happy / not too happy), recoded to a binary `is_very_happy` indicator
- **Explanatory variables:**
  - `wrkslf` — self-employed vs. employed by others
  - `hrs1` — hours worked per week
  - `realrinc` — real income
  - Controls: age (+ quadratic term), education, race, sex

## Methods

- Cleaned and recoded categorical variables into indicator (dummy) variables
- Removed implausible values (e.g., hours worked > 89 treated as missing/miscoded)
- Built three exploratory visualizations to test relationships before modeling
- Fit a linear probability model with an interaction term (`hrs1 * sex_female`), justified by visually distinct slopes for men and women in exploratory plots
- Used `log(realrinc)` to address skew in income

**Tools:** R, `tidyverse`, `haven`, `lmtest`, `sandwich`, `skimr`

## Key Findings

- **Self-employment** is associated with a statistically significant increase in the probability of being very happy (p < 0.001)
- **Income** (log-transformed) is positively and significantly associated with happiness
- **Hours worked** has a small positive effect for men, but the interaction term shows this effect is significantly weaker for women — additional hours worked affect the sexes differently
- **Age** shows a U-shaped (quadratic) relationship with happiness
- Model fit is modest (R² ≈ 0.011), consistent with happiness being driven by many factors beyond work characteristics — the goal here was identifying significant relationships, not maximizing predictive power

## Visualizations

Three exploratory plots precede the regression: happiness by employment type (bar chart), happiness vs. hours worked by gender (locally smoothed), and happiness vs. income by employment type — each used to justify a modeling decision (e.g., the interaction term).

## Limitations

- Linear probability model on a binary outcome — coefficients approximate marginal effects but can produce predicted probabilities outside [0,1]
- Cross-sectional data; relationships are associational, not causal
- Low R² means omitted variables (e.g., job satisfaction, health, relationship status) likely explain more variance than the included predictors

## Files

- `happiness_regression.Rmd` — full analysis with code, visualizations, and regression output
- Rendered HTML/PDF output

---
*Authors: Alexis Ortiz, Luke Lisi, Victor Sainz*
