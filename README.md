



\# Enhanced Seasonal Malaria Chemoprevention and Haemoglobin Trajectories



A comprehensive longitudinal Randomised Controlled Trial (RCT) analysis conducted using \*\*R\*\*, \*\*Linear Mixed Models (LMM)\*\*, and advanced statistical methods to evaluate the impact of Enhanced Seasonal Malaria Chemoprevention (SMC) on haemoglobin trajectories in children during the rainy season in sub-Saharan Africa.



The study was designed with a strong focus on \*\*statistical rigor\*\*, \*\*model validation\*\*, \*\*data integrity\*\*, and \*\*evidence-based policy recommendations\*\* to support national malaria control programs.



\---



\## Project Overview



Malaria-associated anaemia remains a leading cause of childhood morbidity in sub-Saharan Africa. Standard Seasonal Malaria Chemoprevention (SMC) reduces clinical malaria incidence but has limited haematological impact, as it does not address the nutritional deficits that accompany repeated infections.



This study evaluated whether an \*\*Enhanced SMC protocol\*\*, combining standard antimalarials with high-dose iron and nutritional supplementation, produces superior haemoglobin trajectories compared to \*\*Standard SMC\*\* over six months during the rainy season.



The analysis addresses the following research question:



> Does Enhanced SMC produce significantly better haemoglobin trajectories over six months than Standard SMC, after controlling for age and bed-net use?



\---



\## Key Findings



| Parameter | Estimate | 95% CI | P-value |

|-----------|----------|--------|---------|

| \*\*Treatment × Month Interaction\*\* | 0.205 g/dL/month | \[0.177, 0.232] | <0.001 |

| \*\*ITN Use (Consistent)\*\* | 0.430 g/dL | — | <0.001 |

| \*\*Age at Baseline\*\* | 0.021 g/dL/month | — | <0.001 |



\- \*\*Cumulative Advantage:\*\* ≈1.23 g/dL higher haemoglobin by month 6 for Enhanced SMC arm

\- \*\*ICC:\*\* 0.704 → justified use of Linear Mixed Model

\- \*\*Best Model:\*\* Random intercept + random slope (LRT: χ² = 10.24, p = 0.006)

\- All diagnostic assumptions were reasonably satisfied



\---



\## Study Design



\### Population



\- \*\*Sample Size:\*\* 300 children

\- \*\*Time Points:\*\* Months 0, 2, 4, 6

\- \*\*Total Observations:\*\* 1,200

\- \*\*Setting:\*\* Rainy season in sub-Saharan Africa



\### Treatment Arms



| Arm | Description |

|-----|-------------|

| \*\*Standard SMC (Control)\*\* | Standard antimalarial chemoprevention |

| \*\*Enhanced SMC (Intervention)\*\* | Standard antimalarials + high-dose iron + nutritional supplementation |



\### Primary Outcome



\- \*\*Haemoglobin concentration\*\* (g/dL)



\### Covariates



\- \*\*Age at enrolment\*\* (months)

\- \*\*Insecticide-Treated Net (ITN) use:\*\* Consistent or Inconsistent



\---



\## Methodology



\### Statistical Methods



\- \*\*Exploratory Data Analysis:\*\* Spaghetti plots, LOESS-smoothed population means, boxplots by time point, faceted plots by ITN use and age group

\- \*\*Linear Mixed Models (LMM):\*\* Fitted using `lme4` and `lmerTest` packages in R

\- \*\*Model Selection:\*\* Likelihood Ratio Tests (LRT) comparing random intercept only vs. random intercept + random slope models

\- \*\*Model Diagnostics:\*\* Residuals vs fitted plots, Q-Q plots for residuals, random intercepts, and random slopes

\- \*\*Inference:\*\* Satterthwaite degrees-of-freedom approximation for p-values



\### Model Specification



\*\*Model 0 – Unconditional Means (ICC calculation):\*\*

```

Hb\_ij = β0 + b0i + ε\_ij

```



\*\*Model 1 – Fixed effects, random intercept:\*\*

```

Hb\_ij = β0 + β1(month) + β2(Tx) + β3(age) + β4(ITN) + b0i + ε\_ij

```



\*\*Model 2 – Treatment × Month interaction, random intercept:\*\*

```

Hb\_ij = β0 + β1(month) + β2(Tx) + β3(month×Tx) + β4(age) + β5(ITN) + b0i + ε\_ij

```



\*\*Model 3 – Random intercept + random slope (Final Model):\*\*

```

Hb\_ij = β0 + β1(month) + β2(Tx) + β3(month×Tx) + β4(age) + β5(ITN) + b0i + b1i(month) + ε\_ij

```



\---



\## Visualizations



\### Figure 1: Individual Haemoglobin Trajectories

Spaghetti plots for 40 children per arm with LOESS-smoothed population means and 95% CI



\### Figure 2: Mean Haemoglobin Trajectories

Mean trajectories by treatment arm with 95% CI error bars at each time point



\### Figure 3: Haemoglobin Distributions

Boxplots by time point and treatment arm



\### Figure 4-5: ITN Use Stratification

Haemoglobin distributions and trajectories by ITN use



\### Figure 6: Age Group Stratification

Trajectories faceted by age group (median split)



\### Figure 7-8: Model Diagnostics

Residuals vs fitted plot and Q-Q plots for model validation



\### Figure 9: Model-Predicted Trajectories

Marginal haemoglobin trajectories at mean age and consistent ITN use



\---



\## System Architecture



```text

Simulated RCT Data

&#x20;   │

&#x20;   ▼

Exploratory Data Analysis

&#x20;   │

&#x20;   ▼

Model Building

&#x20;   │

&#x20;   ├── Model 0: Unconditional Means (ICC)

&#x20;   ├── Model 1: Fixed Effects + Random Intercept

&#x20;   ├── Model 2: Treatment×Month Interaction

&#x20;   └── Model 3: Random Intercept + Random Slope ★

&#x20;   │

&#x20;   ▼

Model Selection (LRT: χ² = 10.24, p = 0.006)

&#x20;   │

&#x20;   ▼

Model Diagnostics

&#x20;   │

&#x20;   ▼

Confirmatory Analysis

&#x20;   │

&#x20;   ▼

Policy Recommendations

```



\---



\## Repository Structure



```

smc-haemoglobin-analysis/

│

├── Data.csv                    # Simulated RCT dataset

├── Rcodes.R                    # Complete analysis script

├── Report.pdf                  # Final project report

└── README.md                   # This file

```



\---



\## Dataset Description



The dataset contains \*\*1,200 observations\*\* (300 children × 4 time points):



| Variable | Description |

|----------|-------------|

| `child\_id` | Unique identifier for each child |

| `month` | Time point: 0, 2, 4, 6 |

| `treatment` | Standard SMC or Enhanced SMC |

| `haemoglobin` | Primary outcome (g/dL) |

| `age` | Age at enrolment (months) |

| `itn\_use` | Consistent or Inconsistent ITN use |



\---



\## Technologies Used



\### Statistical Software

\- \*\*R\*\* version 4.5.2



\### R Packages

\- \*\*lme4\*\* – Linear Mixed Models

\- \*\*lmerTest\*\* – p-values and Satterthwaite approximation

\- \*\*tidyverse\*\* – Data manipulation and visualization

\- \*\*finalfit\*\* – Summary tables

\- \*\*broom.mixed\*\* – Model output tidying

\- \*\*kableExtra\*\* – Table formatting

\- \*\*ggplot2\*\* – Visualizations



\---



\## Installation



\### 1. Clone the Repository



```bash

git clone https://github.com/Claude-2Rachande/smc-haemoglobin-analysis.git

cd smc-haemoglobin-analysis

```



\### 2. Open RStudio



```bash

open RStudio

```



\### 3. Install Required Packages



```r

install.packages(c("lme4", "lmerTest", "tidyverse", "finalfit", "broom.mixed", "kableExtra"))

```



\### 4. Load Packages



```r

library(lme4)

library(lmerTest)

library(tidyverse)

library(finalfit)

library(broom.mixed)

library(kableExtra)

```



\### 5. Run the Analysis



Open `Rcodes.R` and run the script from top to bottom.



\---



\## How to Reproduce



1\. Clone or download this repository

2\. Open `Rcodes.R` in RStudio

3\. Run the script from top to bottom



The script will:

\- Load and explore the dataset

\- Generate all figures

\- Fit and compare LMMs

\- Run model diagnostics

\- Produce the final model output



\---



\## Key Statistical Concepts Demonstrated



This project demonstrates practical implementation of:



\- \*\*Randomised Controlled Trial (RCT) Analysis\*\*

\- \*\*Linear Mixed Models (LMM)\*\*

\- \*\*Intraclass Correlation Coefficient (ICC)\*\*

\- \*\*Likelihood Ratio Tests (LRT)\*\*

\- \*\*Model Selection Criteria (AIC, BIC)\*\*

\- \*\*Satterthwaite Degrees-of-Freedom Approximation\*\*

\- \*\*Model Diagnostics (Residuals, Q-Q Plots)\*\*

\- \*\*Treatment × Time Interactions\*\*

\- \*\*Covariate Adjustment (Age, ITN Use)\*\*

\- \*\*Random Intercept and Random Slope Models\*\*

\- \*\*Data Visualization for Longitudinal Data\*\*



\---



\## Project Achievements



Successfully implemented:



\- Simulated longitudinal RCT dataset with 1,200 observations

\- Comprehensive exploratory data analysis with 9 visualization panels

\- Four LMMs with progressive complexity

\- Model selection via Likelihood Ratio Test

\- Complete model diagnostics and assumption checking

\- Clinically meaningful effect estimation

\- Evidence-based policy recommendations



\---



\## Policy Recommendations



Based on the statistical evidence, this study recommends:



1\. \*\*National scale-up\*\* of the Enhanced SMC protocol

2\. \*\*Cost-effectiveness analysis\*\* of the supplementation component

3\. \*\*Multi-site confirmatory trial\*\* to verify generalisability

4\. \*\*Sub-group analyses\*\* by baseline anaemia severity to optimize targeting



\---



\## Limitations



\- \*\*Simulated Dataset:\*\* Complete adherence was assumed

\- \*\*Time-Varying Confounders:\*\* Not modelled

\- \*\*Follow-up Duration:\*\* Longer follow-up needed to confirm persistence of benefit beyond rainy season

\- \*\*Generalizability:\*\* Real-world validation needed



\---



\## Author



\*\*Jean Claude Maniriho\*\*



Mastercard Foundation Scholar at AIMS Rwanda pursuing a Master's degree in Mathematical Sciences (Epidemiology), with a strong academic foundation in Mathematical Statistics from the University of Rwanda.



I am a \*\*Full-Stack Developer\*\*, \*\*Data Scientist\*\*, and \*\*Researcher\*\* passionate about applying mathematics, statistics, software engineering, and machine learning to solve real-world problems in public health, education, and decision-making systems.



Currently involved in research on the effects of climate change indicators on the spatial distribution of malaria infections among school children in Kenya, in collaboration with AIMS Rwanda and KEMRI.



\---



\## Technical Skills



| Domain | Skills |

|--------|--------|

| \*\*Programming\*\* | Python, R, MATLAB, SQL |

| \*\*Web Development\*\* | Django, HTML, CSS, JavaScript |

| \*\*Data Analysis\*\* | Statistical Modeling, Machine Learning, Survival Analysis, Spatial Data Analysis |

| \*\*Database\*\* | SQLite, PostgreSQL |

| \*\*Version Control\*\* | Git, GitHub |



\---



\## Areas of Interest



\- Epidemiology

\- Data Science

\- Artificial Intelligence

\- Software Development

\- Public Health Analytics

\- Climate and Health Research

\- Database Systems

\- Decision Science



\---



\## Connect with Me



\- \*\*GitHub:\*\* \[github.com/Claude-2Rachande](https://github.com/Claude-2Rachande)

\- \*\*LinkedIn:\*\* \[jean-claude-maniriho](https://www.linkedin.com/in/jean-claude-maniriho-691253289/)



\---



\## References



Full reference list is available in the \*\*Report.pdf\*\* file included in this repository.



\---



\## Vision



My goal is to develop innovative data-driven and technology-based solutions that contribute to improving healthcare systems, education, and evidence-based decision-making across Africa.



\---



\## License



\*\*MIT License\*\*



Copyright (c) 2026 Jean Claude Maniriho



Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:



The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



\---



\## Team



\- \*\*Jean Claude Maniriho\*\* – Lead Analyst

\- \*\*Kutlo Kejang\*\* – Co-Author

\- \*\*Yosamu Muhanzi\*\* – Co-Author

\- \*\*Joshua Opio\*\* – Co-Author

\- \*\*Grace Kitonyi\*\* – Co-Author



\*\*Institution:\*\* African Institute for Mathematical Sciences (AIMS) Rwanda  

\*\*Course:\*\* Advanced Data Analysis Methods  

\*\*Date:\*\* March 2026



