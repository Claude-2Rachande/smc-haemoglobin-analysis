#  🔁  Enhanced Seasonal Malaria Chemoprevention and Haemoglobin Trajectories

[![R](https://img.shields.io/badge/R-4.5.2-276DC3?style=flat-square&logo=r&logoColor=white)](https://www.r-project.org/)
[![lme4](https://img.shields.io/badge/lme4-Mixed%20Models-1f6feb?style=flat-square)](https://cran.r-project.org/package=lme4)
[![tidyverse](https://img.shields.io/badge/tidyverse-Data%20Wrangling-1a162d?style=flat-square&logo=tidyverse&logoColor=white)](https://www.tidyverse.org/)
[![ggplot2](https://img.shields.io/badge/ggplot2-Visualization-276DC3?style=flat-square)](https://ggplot2.tidyverse.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](#-license)

A comprehensive longitudinal Randomised Controlled Trial (RCT) analysis evaluating the impact of Enhanced Seasonal Malaria Chemoprevention (SMC) on haemoglobin trajectories in children during the rainy season in sub-Saharan Africa.

Built with a strong focus on **statistical rigor**, **model validation**, **data integrity**, and **evidence-based policy recommendations** to support national malaria control programs.

---

##  Project Overview

Malaria-associated anaemia remains a leading cause of childhood morbidity in sub-Saharan Africa. Standard Seasonal Malaria Chemoprevention (SMC) reduces clinical malaria incidence but has limited haematological impact, as it does not address the nutritional deficits that accompany repeated infections.

This study evaluated whether an **Enhanced SMC protocol**, combining standard antimalarials with high-dose iron and nutritional supplementation, produces superior haemoglobin trajectories compared to **Standard SMC** over six months during the rainy season.

> **Research Question:** Does Enhanced SMC produce significantly better haemoglobin trajectories over six months than Standard SMC, after controlling for age and bed-net use?

---

##  Key Findings

| Parameter | Estimate | 95% CI | P-value |
|---|---|---|---|
| **Treatment × Month Interaction** | 0.205 g/dL/month | [0.177, 0.232] | < 0.001 |
| **ITN Use (Consistent)** | 0.430 g/dL | — | < 0.001 |
| **Age at Baseline** | 0.021 g/dL/month | — | < 0.001 |

| Metric | Result |
|---|---|
|  **Cumulative Advantage** | ≈1.23 g/dL higher haemoglobin by month 6 for the Enhanced SMC arm |
|  **ICC** | 0.704 → justified use of a Linear Mixed Model |
|  **Best Model** | Random intercept + random slope (LRT: χ² = 10.24, p = 0.006) |
|  **Diagnostics** | All assumptions reasonably satisfied |

---

##  Study Design

### Population

| Attribute | Detail |
|---|---|
| **Sample Size** | 300 children |
| **Time Points** | Months 0, 2, 4, 6 |
| **Total Observations** | 1,200 |
| **Setting** | Rainy season in sub-Saharan Africa |

### Treatment Arms

| Arm | Description |
|---|---|
| **Standard SMC (Control)** | Standard antimalarial chemoprevention |
| **Enhanced SMC (Intervention)** | Standard antimalarials + high-dose iron + nutritional supplementation |

### Primary Outcome

- **Haemoglobin concentration** (g/dL)

### Covariates

- **Age at enrolment** (months)
- **Insecticide-Treated Net (ITN) use:** Consistent or Inconsistent

---

##  Methodology

### Statistical Methods

- **Exploratory Data Analysis:** Spaghetti plots, LOESS-smoothed population means, boxplots by time point, faceted plots by ITN use and age group
- **Linear Mixed Models (LMM):** Fitted using `lme4` and `lmerTest` packages in R
- **Model Selection:** Likelihood Ratio Tests (LRT) comparing random-intercept-only vs. random-intercept-plus-random-slope models
- **Model Diagnostics:** Residuals vs. fitted plots, Q-Q plots for residuals, random intercepts, and random slopes
- **Inference:** Satterthwaite degrees-of-freedom approximation for p-values

### Model Specification

**Model 0 — Unconditional Means (ICC calculation):**
```
Hb_ij = β0 + b0i + ε_ij
```

**Model 1 — Fixed effects, random intercept:**
```
Hb_ij = β0 + β1(month) + β2(Tx) + β3(age) + β4(ITN) + b0i + ε_ij
```

**Model 2 — Treatment × Month interaction, random intercept:**
```
Hb_ij = β0 + β1(month) + β2(Tx) + β3(month×Tx) + β4(age) + β5(ITN) + b0i + ε_ij
```

**Model 3 — Random intercept + random slope (Final Model):**
```
Hb_ij = β0 + β1(month) + β2(Tx) + β3(month×Tx) + β4(age) + β5(ITN) + b0i + b1i(month) + ε_ij
```

---

## 📈 Visualizations

| Figure | Description |
|---|---|
| **Figure 1** | Individual haemoglobin trajectories — spaghetti plots for 40 children per arm with LOESS-smoothed population means and 95% CI |
| **Figure 2** | Mean haemoglobin trajectories by treatment arm with 95% CI error bars at each time point |
| **Figure 3** | Haemoglobin distributions — boxplots by time point and treatment arm |
| **Figures 4–5** | ITN use stratification — haemoglobin distributions and trajectories by ITN use |
| **Figure 6** | Age group stratification — trajectories faceted by age group (median split) |
| **Figures 7–8** | Model diagnostics — residuals vs. fitted plot and Q-Q plots for model validation |
| **Figure 9** | Model-predicted trajectories — marginal haemoglobin trajectories at mean age and consistent ITN use |

---

## 📁 Repository Structure

```
smc-haemoglobin-analysis/
│
├── Data.csv          # Simulated RCT dataset
├── Rcodes.R           # Complete analysis script
├── Report.pdf          # Final project report
└── README.md          # This file
```

---

##  Dataset Description

The dataset contains **1,200 observations** (300 children × 4 time points):

| Variable | Description |
|---|---|
| `child_id` | Unique identifier for each child |
| `month` | Time point: 0, 2, 4, 6 |
| `treatment` | Standard SMC or Enhanced SMC |
| `haemoglobin` | Primary outcome (g/dL) |
| `age` | Age at enrolment (months) |
| `itn_use` | Consistent or Inconsistent ITN use |

---

##  Technologies Used

| Layer | Stack |
|---|---|
|  **Statistical Software** | R version 4.5.2 |
|  **Modeling** | lme4, lmerTest |
|  **Data Wrangling** | tidyverse |
|  **Reporting** | finalfit, broom.mixed, kableExtra |
|  **Visualization** | ggplot2 |

---

##  Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Claude-2Rachande/smc-haemoglobin-analysis.git
cd smc-haemoglobin-analysis
```

### 2. Open RStudio

```bash
open RStudio
```

### 3. Install Required Packages

```r
install.packages(c("lme4", "lmerTest", "tidyverse", "finalfit", "broom.mixed", "kableExtra"))
```

### 4. Load Packages

```r
library(lme4)
library(lmerTest)
library(tidyverse)
library(finalfit)
library(broom.mixed)
library(kableExtra)
```

### 5. Run the Analysis

Open `Rcodes.R` and run the script from top to bottom.

---

## How to Reproduce

1. Clone or download this repository
2. Open `Rcodes.R` in RStudio
3. Run the script from top to bottom

The script will:

- Load and explore the dataset
- Generate all figures
- Fit and compare LMMs
- Run model diagnostics
- Produce the final model output

---

##  Key Statistical Concepts Demonstrated

This project demonstrates practical implementation of:

- Randomised Controlled Trial (RCT) Analysis
- Linear Mixed Models (LMM)
- Intraclass Correlation Coefficient (ICC)
- Likelihood Ratio Tests (LRT)
- Model Selection Criteria (AIC, BIC)
- Satterthwaite Degrees-of-Freedom Approximation
- Model Diagnostics (Residuals, Q-Q Plots)
- Treatment × Time Interactions
- Covariate Adjustment (Age, ITN Use)
- Random Intercept and Random Slope Models
- Data Visualization for Longitudinal Data

---

##  Policy Recommendations

Based on the statistical evidence, this study recommends:

1. **National scale-up** of the Enhanced SMC protocol
2. **Cost-effectiveness analysis** of the supplementation component
3. **Multi-site confirmatory trial** to verify generalisability
4. **Sub-group analyses** by baseline anaemia severity to optimize targeting

---

## ⚠️ Limitations

- **Simulated Dataset:** Complete adherence was assumed
- **Time-Varying Confounders:** Not modelled
- **Follow-up Duration:** Longer follow-up needed to confirm persistence of benefit beyond the rainy season
- **Generalizability:** Real-world validation needed

---

##  Author

**Jean Claude Maniriho**

Mastercard Foundation Scholar at AIMS Rwanda pursuing a Master's degree in Mathematical Sciences (Epidemiology). Currently researching the effects of climate change indicators on the spatial distribution of malaria infections among school children in Kenya, in collaboration with AIMS Rwanda and KEMRI.

[![GitHub](https://img.shields.io/badge/GitHub-Claude--2Rachande-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/Claude-2Rachande)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Jean%20Claude%20Maniriho-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/jean-claude-maniriho-691253289/)

---

##  References

Full reference list is available in the **Report.pdf** file included in this repository.

---

##  License

**MIT License**

Copyright (c) 2026 Jean Claude Maniriho

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

## 🤝 Team

- **Jean Claude Maniriho** — Lead Analyst & Repository Maintainer
- **Kutlo Kejang** — Co-Author
- **Yosamu Muhanzi** — Co-Author
- **Joshua Opio** — Co-Author
- **Grace Kitonyi** — Co-Author

**Institution:** African Institute for Mathematical Sciences (AIMS) Rwanda
**Date:** March 2026
