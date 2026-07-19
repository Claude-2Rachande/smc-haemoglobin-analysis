# ADAM Project Title: Impact of Enhanced Seasonal Malaria Chemoprevention on
# Haemoglobin Trajectories .

# Clean environment
rm(list = ls())

# Packages
#install.packages("lme4")
#install.packages("lmerTest")
#install.packages("finalfit")
#install.packages("tidyverse")
#install.packages("broom.mixed")
library(dplyr)
library(lme4)
library(lmerTest)
library(finalfit)
library(tidyverse)
library(broom.mixed)
library(knitr)
library(kableExtra)

########## Task 0: Data Import & Cleaning ##########

data = read.csv("malaria_anemia_rct.csv")

head(data)
str(data)

# Missing values
sum(is.na(data))

# Range checks
summary(data)

# Plausibility check: flag implausible haemoglobin values
impausible = data %>% filter(hemoglobin < 5 | hemoglobin > 20)
impausible

# Observation balance: every child should have 4 observations
obs_count = data %>% count(child_id)
table(obs_count$n)

# Recode variables
data = data %>%
  mutate(
    child_id     = factor(child_id),
    treatment    = factor(treatment, levels = c(0, 1),
                          labels = c("Standard SMC", "Enhanced SMC")),
    itn_use      = factor(itn_use, levels = c(0, 1),
                          labels = c("Inconsistent", "Consistent")))

str(data)
View(data)
sum(data$month == 0 & data$treatment == "Standard SMC")
sum(data$month == 0 & data$treatment == "Enhanced SMC")

# Baseline subset (month == 0 only)
data_baseline = dplyr::filter(data, month == 0)

########## Task 1: Exploratory Data Analysis (EDA) ##########

# Display labels using ff_label
data_baseline = data_baseline %>%
  mutate(
    age_baseline = ff_label(age_baseline, "Age at Baseline (months)"),
    itn_use      = ff_label(itn_use,      "ITN Use"),
    hemoglobin   = ff_label(hemoglobin,   "Haemoglobin (g/dL)"),
    treatment    = ff_label(treatment,    "Treatment Group")
  )

# Baseline characteristics table
desc_statistics = data_baseline %>%
  summary_factorlist(
    dependent           = "treatment",
    explanatory         = c("age_baseline", "itn_use", "hemoglobin"),
    p                   = TRUE,
    add_dependent_label = TRUE,
    cont                = "mean",
    add_col_totals      = TRUE,
    add_row_totals      = TRUE
  )

# Rename columns
desc_statistics = desc_statistics %>%
  mutate(`Dependent: Treatment Group` = ifelse(
    `Dependent: Treatment Group` == "Total N (%)",
    "Total Participants, N (%)",
    `Dependent: Treatment Group`
  )) %>%
  rename(
    `Characteristic`            = `Dependent: Treatment Group`,
    `Total Participants, N (%)` = `Total N`,
    `Missing, N`                = `Missing N`,
    `p-value`                   = p
)

# Display table
desc_statistics %>%
  kable() %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width        = FALSE
  ) %>%
  row_spec(0, bold = TRUE) %>%
  footnote(general = paste0(
    "Continuous variables: Mean (SD). Categorical: N (%). ",
    "p-values: t-test (continuous), chi-squared (categorical). ",
    "Non-significant p-values indicate effective randomisation. ",
    "ITN = Insecticide-Treated Net."))

# Table 2: Haemoglobin summary by treatment arm and time point
hb_summary = data %>%
  group_by(Treatment = treatment, Month = month) %>%
  summarise(
    N    = n(),
    Mean = round(mean(hemoglobin), 2),
    SD   = round(sd(hemoglobin), 2),
    Min  = round(min(hemoglobin), 2),
    Max  = round(max(hemoglobin), 2),
    .groups = "drop")

kable(hb_summary) %>%
  kable_styling(bootstrap_options = "striped", full_width = FALSE)

# Histogram: baseline haemoglobin
hist(data_baseline$hemoglobin,
     probability = TRUE,
     main = "Histogram of Baseline Haemoglobin",
     xlab = "Haemoglobin (g/dL)",
     col  = "lightblue")
lines(density(data_baseline$hemoglobin), col = "firebrick", lwd = 3)

# Histogram: age at baseline
hist(data_baseline$age_baseline,
     probability = TRUE,
     main = "Histogram of Age at Baseline",
     xlab = "Age (months)",
     col  = "yellow")
lines(density(data_baseline$age_baseline), col = "magenta", lwd = 4)

# Violin + boxplot: baseline haemoglobin by treatment
ggplot(data_baseline, aes(x = treatment, y = hemoglobin)) +
  geom_violin(trim = FALSE, fill = "pink") +
  geom_boxplot(width = 0.15, fill = "lightgreen") +
  labs(title = "Baseline haemoglobin distribution by treatment arm",
       x = "Treatment", y = "Haemoglobin (g/dL)") +
  theme_minimal()

# Violin + boxplot: age by treatment
ggplot(data_baseline, aes(x = treatment, y = age_baseline)) +
  geom_violin(trim = FALSE, fill = "gray") +
  geom_boxplot(width = 0.15, fill = "purple") +
  labs(title = "Age distribution by treatment arm",
       x = "Treatment", y = "Age (months)") +
  theme_minimal()

# Stacked bar: ITN use by treatment
ggplot(data_baseline, aes(x = treatment, fill = itn_use)) +
  geom_bar(position = "stack") +
  labs(title = "Distribution of ITN use by treatment arm",
       x = "Treatment", y = "Count of Participants", fill = "ITN Use") +
  scale_fill_manual(values = c("gray", "orange")) +
  theme_minimal()

# Spaghetti plot: individual trajectories + LOESS mean per arm
set.seed(2026)
sampled_ids = data_baseline %>%
  group_by(treatment) %>%
  slice_sample(n = 40) %>%
  pull(child_id)

data_sample = data %>% filter(child_id %in% sampled_ids)

ggplot() +
  geom_line(data = data_sample,
            aes(x = month, y = hemoglobin,
                group = child_id, colour = treatment),
            alpha = 0.25, linewidth = 0.4) +
  geom_point(data = data_sample,
             aes(x = month, y = hemoglobin, colour = treatment),
             alpha = 0.15, size = 0.8) +
  geom_smooth(data = data,
              aes(x = month, y = hemoglobin,
                  colour = treatment, fill = treatment),
              method = "loess", se = TRUE,
              linewidth = 1.2, alpha = 0.15) +
  scale_x_continuous(breaks = c(0, 2, 4, 6),
                     labels = c("Baseline\n(0)", "Month 2",
                                "Month 4", "Month 6")) +
  scale_colour_manual(values = c("Standard SMC" = "purple",
                                  "Enhanced SMC"  = "orange")) +
  scale_fill_manual(values   = c("Standard SMC" = "purple",
                                  "Enhanced SMC"  = "orange")) +
  labs(title    = "Haemoglobin trajectories by treatment arm",
       subtitle = "Individual trajectories (n = 40/arm) with LOESS population mean (95% CI shaded)",
       x = "Month", y = "Haemoglobin (g/dL)",
       colour = "Treatment", fill = "Treatment") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Mean trajectory plot with 95% CI error bars
hb_means = data %>%
  group_by(treatment, month) %>%
  summarise(
    mean_hb = mean(hemoglobin),
    se_hb   = sd(hemoglobin) / sqrt(n()),
    .groups = "drop"
  )

ggplot(hb_means, aes(x = month, y = mean_hb,
                      colour = treatment, group = treatment)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = mean_hb - 1.96 * se_hb,
                    ymax = mean_hb + 1.96 * se_hb),
                width = 0.3, linewidth = 0.8) +
  scale_x_continuous(breaks = c(0, 2, 4, 6)) +
  scale_colour_manual(values = c("Standard SMC" = "purple",
                                  "Enhanced SMC"  = "orange")) +
  labs(title    = "Mean haemoglobin trajectories by treatment arm",
       subtitle = "Error bars = 95% confidence intervals",
       x = "Month", y = "Mean Haemoglobin (g/dL)",
       colour = "Treatment") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Boxplot: haemoglobin distribution by time point and treatment
ggplot(data, aes(x = factor(month), y = hemoglobin, fill = treatment)) +
  geom_boxplot(outlier.size = 0.8, alpha = 0.75) +
  scale_fill_manual(values = c("Standard SMC" = "magenta",
                                "Enhanced SMC"  = "blue")) +
  scale_x_discrete(labels = c("0" = "Baseline", "2" = "Month 2",
                               "4" = "Month 4", "6" = "Month 6")) +
  labs(title = "Haemoglobin distribution by time point and treatment",
       x = "Time Point", y = "Haemoglobin (g/dL)", fill = "Treatment") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Haemoglobin distribution by ITN use at each time point
ggplot(data, aes(x = factor(month), y = hemoglobin, fill = itn_use)) +
  geom_boxplot(outlier.size = 0.8, alpha = 0.75) +
  scale_fill_manual(values = c("Inconsistent" = "darkgreen",
                               "Consistent"   = "brown")) +
  scale_x_discrete(labels = c("0" = "Baseline", "2" = "Month 2",
                              "4" = "Month 4", "6" = "Month 6")) +
  labs(title = "Haemoglobin distribution by ITN use at each time point",
       x = "Time Point", y = "Haemoglobin (g/dL)",
       fill = "ITN Use") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Spaghetti plot faceted by ITN use
ggplot() +
  geom_line(data = data_sample,
            aes(x = month, y = hemoglobin,
                group = child_id, colour = treatment),
            alpha = 0.25, linewidth = 0.4) +
  geom_smooth(data = data,
              aes(x = month, y = hemoglobin,
                  colour = treatment, fill = treatment),
              method = "loess", se = TRUE,
              linewidth = 1.2, alpha = 0.15) +
  facet_wrap(~ itn_use, labeller = label_both) +
  scale_x_continuous(breaks = c(0, 2, 4, 6)) +
  scale_colour_manual(values = c("Standard SMC" = "maroon",
                                 "Enhanced SMC"  = "blue")) +
  scale_fill_manual(values   = c("Standard SMC" = "maroon",
                                 "Enhanced SMC"  = "blue")) +
  labs(title    = "Haemoglobin trajectories by treatment arm, faceted by ITN use",
       subtitle = "Individual trajectories with LOESS population mean (95% CI shaded)",
       x = "Month", y = "Haemoglobin (g/dL)",
       colour = "Treatment", fill = "Treatment") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Spaghetti plot faceted by age group
# Create age groups first (younger vs older split at median)
data = data %>%
  mutate(age_group = ifelse(age_baseline < median(data$age_baseline),
                            "Younger (Below Median Age)",
                            "Older (Above Median Age)"))

data_sample = data %>% filter(child_id %in% sampled_ids)

ggplot() +
  geom_line(data = data_sample,
            aes(x = month, y = hemoglobin,
                group = child_id, colour = treatment),
            alpha = 0.25, linewidth = 0.4) +
  geom_smooth(data = data,
              aes(x = month, y = hemoglobin,
                  colour = treatment, fill = treatment),
              method = "loess", se = TRUE,
              linewidth = 1.2, alpha = 0.15) +
  facet_wrap(~ age_group) +
  scale_x_continuous(breaks = c(0, 2, 4, 6)) +
  scale_colour_manual(values = c("Standard SMC" = "darkgreen",
                                 "Enhanced SMC"  = "orange")) +
  scale_fill_manual(values   = c("Standard SMC" = "darkgreen",
                                 "Enhanced SMC"  = "orange")) +
  labs(title    = "Haemoglobin trajectories by treatment arm, faceted by age group",
       subtitle = "Individual trajectories with LOESS population mean (95% CI shaded)",
       x = "Month", y = "Haemoglobin (g/dL)",
       colour = "Treatment", fill = "Treatment") +
  theme_minimal() +
  theme(legend.position = "bottom")

########## Task 2: Model Building & Selection ##########

# Model 0: Unconditional means model - calculates ICC
m0 = lmer(hemoglobin ~ 1 + (1 | child_id), data = data)
summary(m0)

# ICC
vc0   = VarCorr(m0)
var_b = as.numeric(vc0$child_id)
var_w = attr(vc0, "sc")^2
icc   = var_b / (var_b + var_w)
icc

# ICC table
icc_tbl = data.frame(
  Component = c("Between-child variance (σ₀²)",
                "Within-child variance (σₑ²)",
                "Total variance",
                "ICC"),
  Estimate  = c(round(var_b, 4),
                round(var_w, 4),
                round(var_b + var_w, 4),
                round(icc, 4)))

kable(icc_tbl,
      col.names = c("Variance Component", "Estimate")) %>%
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  row_spec(4, bold = TRUE, background = "lightblue") %>%
  footnote(general = paste0(
    "ICC = between-child variance / total variance. ",
    "Values > 0.05 justify the use of a linear mixed model."))

# Model 1: Main fixed effects + random intercept (no interaction)
m1 = lmer(hemoglobin ~ month + treatment + age_baseline + itn_use +
            (1 | child_id),
          data = data)
summary(m1)

# Model 2: Add treatment x month interaction + random intercept
m2 = lmer(hemoglobin ~ month * treatment + age_baseline + itn_use +
            (1 | child_id),
          data = data)
summary(m2)

# Model 3: Add random slope for month
m3 = lmer(hemoglobin ~ month * treatment + age_baseline + itn_use +
            (month | child_id),
          data = data,
          control = lmerControl(optimizer = "bobyqa",
                                optCtrl = list(maxfun = 2e5)))
summary(m3)

# Model selection: LRT comparing Model 2 vs Model 3
lrt = anova(m2, m3)
lrt

# AIC / BIC / LRT comparison table
model_comp = data.frame(
  Model  = c("M2: Random Intercept Only",
             "M3: Random Intercept + Random Slope"),
  Params = c(lrt$npar[1], lrt$npar[2]),
  AIC    = round(c(lrt$AIC[1], lrt$AIC[2]), 2),
  BIC    = round(c(lrt$BIC[1], lrt$BIC[2]), 2),
  LogLik = round(c(lrt$logLik[1], lrt$logLik[2]), 2),
  LRT_p  = c("-", ifelse(lrt$`Pr(>Chisq)`[2] < 0.001, "< 0.001",
                         round(lrt$`Pr(>Chisq)`[2], 3)))
)

kable(model_comp,
      col.names = c("Model", "Parameters", "AIC", "BIC",
                    "Log-Likelihood", "LRT p-value")) %>%
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  footnote(general = paste0(
    "Lower AIC/BIC = better fit. LRT p < 0.05 indicates the random slope ",
    "significantly improves model fit. ",
    "Models estimated by maximum likelihood (ML) for comparison."))

# Select and refit final model with REML
lrt_p = lrt$`Pr(>Chisq)`[2]

if (!is.na(lrt_p) && lrt_p < 0.05) {
  final_model      = update(m3, REML = TRUE)
  final_model_name = "Random Intercept + Random Slope (Model 3)"
} else {
  final_model      = update(m2, REML = TRUE)
  final_model_name = "Random Intercept Only (Model 2)"
}

summary(final_model)

########## Task 3: Model Diagnostics ##########

resid_vals  = residuals(final_model, type = "pearson")
fitted_vals = fitted(final_model)
diag_df     = data.frame(fitted = fitted_vals, residuals = resid_vals)

# Residuals vs Fitted - checks homoscedasticity
ggplot(diag_df, aes(x = fitted, y = residuals)) +
  geom_point(alpha = 0.35, colour = "steelblue", size = 1) +
  geom_hline(yintercept = 0, colour = "maroon", linetype = "dashed", lwd = 1) +
  geom_smooth(method = "loess", colour = "magenta", se = FALSE) +
  labs(title    = "Residuals vs Fitted Values",
       x = "Fitted Values", y = "Pearson Residuals") +
  theme_minimal()

# Q-Q plot: observation-level residuals - checks normality of within-child errors
qqnorm(resid_vals, main = NULL)
title(main = "Q-Q Plot of Observation-Level Residuals")
qqline(resid_vals, col = "green", lwd = 3)

# Q-Q plot: child-level random intercepts - checks normality of random effects
re_int = ranef(final_model)$child_id[, 1]
qqnorm(re_int, main = NULL)
title(main = "Q-Q Plot of Child-Level Random Intercepts")
qqline(re_int, col = "turquoise", lwd = 3)

# Q-Q plot: child-level random slopes
re_slope = ranef(final_model)$child_id[, 2]
qqnorm(re_slope, main = NULL)
title(main = "Q-Q Plot of Child-Level Random Slopes")
qqline(re_slope, col = "orange", lwd = 3)

########## Task 4: Confirmatory Analysis & Public Health Translation ##########

# Fixed effects results table
tidy_fe = broom.mixed::tidy(final_model,
                            effects    = "fixed",
                            conf.int   = TRUE,
                            conf.level = 0.95) %>%
  mutate(
    Estimate = round(estimate, 3),
    SE       = round(std.error, 3),
    CI       = paste0("[", round(conf.low, 3), ", ", round(conf.high, 3), "]"),
    p_value  = case_when(p.value < 0.001 ~ "< 0.001",
                         TRUE ~ as.character(round(p.value, 3))),
    term = recode(term,
      `(Intercept)`                 = "Intercept",
      `month`                       = "Month",
      `treatmentEnhanced SMC`       = "Treatment: Enhanced SMC",
      `age_baseline`                = "Age at baseline (months)",
      `itn_useConsistent`           = "ITN use: Consistent",
      `month:treatmentEnhanced SMC` = "Month x Treatment (Enhanced SMC)")
  ) %>%
  select(term, Estimate, SE, CI, p_value) %>%
  rename(Term = term, `Std. Error` = SE, `95% CI` = CI, `p-value` = p_value)

tidy_fe %>%
  kable(
    col.names = c("Term", "Estimate", "Std. Error", "95% CI", "p-value")
  ) %>%
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  row_spec(which(tidy_fe$Term == "Month x Treatment (Enhanced SMC)"),
           bold = TRUE, background = "lightblue") %>%
  footnote(general = paste0(
    "Reference: Standard SMC, Inconsistent ITN use. ",
    "Highlighted row = primary coefficient of interest. ",
    "p-values via Satterthwaite degrees-of-freedom approximation (lmerTest)."))

# Random effects variance components
vc_final = VarCorr(final_model)

re_tbl = data.frame(
  Component = c("Between-child: Intercept variance (σ₀²)",
                "Between-child: Slope variance (σ₁²)",
                "Within-child: Residual variance (σₑ²)"),
  Estimate  = c(round(as.numeric(vc_final$child_id[1, 1]), 4),
                round(as.numeric(vc_final$child_id[2, 2]), 4),
                round(attr(vc_final, "sc")^2, 4)))

kable(re_tbl,
      col.names = c("Variance Component", "Estimate"),
      escape    = FALSE) %>%
  kable_styling(bootstrap_options = "striped", full_width = FALSE)

# Model-predicted trajectories plot
pred_grid = expand.grid(
  month        = c(0, 2, 4, 6),
  treatment    = levels(data$treatment),
  age_baseline = mean(data_baseline$age_baseline, na.rm = TRUE),
  itn_use      = factor("Consistent", levels = c("Inconsistent", "Consistent"))
)

pred_grid$predicted = predict(final_model, newdata = pred_grid, re.form = NA)

ggplot(pred_grid, aes(x = month, y = predicted,
                       colour = treatment, group = treatment)) +
  geom_line(linewidth = 1.4) +
  geom_point(size = 3.5) +
  scale_x_continuous(breaks = c(0, 2, 4, 6)) +
  scale_colour_manual(values = c("Standard SMC" = "darkred",
                                  "Enhanced SMC"  = "violet")) +
  labs(title    = "Model-predicted haemoglobin trajectories",
       x = "Month", y = "Predicted Haemoglobin (g/dL)",
       colour = "Treatment") +
  theme_minimal() +
  theme(legend.position = "bottom")
