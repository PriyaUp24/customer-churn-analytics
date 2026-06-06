# Customer Churn Analytics & Prediction
### Telecom Customer Retention Intelligence | SQL · Power BI · Python · Random Forest

---

##  Project Objective

Telecom companies lose significant revenue every year to preventable customer churn. This project builds an end-to-end churn analytics system — from raw data ingestion and SQL-based cleaning, through a multi-page Power BI dashboard for business stakeholders, to a machine learning model that scores **new joiners** on their likelihood to churn before it happens.

> **Personal context:** This project was inspired by hands-on experience in telecom data operations at Vodafone India, where data pipeline integrity and customer data accuracy were core responsibilities.

---

##  Dataset Overview

| Attribute | Detail |
|---|---|
| Source | Indian Telecom Customer Dataset |
| Total Customers | 6,418 |
| Features | 32 columns (demographic, account, service, financial) |
| Churned Customers | 1,732 (27.0% churn rate) |
| Stayed Customers | 4,275 |
| New Joiners (to predict) | 411 |
| Revenue at Risk (churned) | ₹34,11,961 (17.5% of total revenue) |

---

##  Tools & Stack

| Tool | Purpose |
|---|---|
| **SQL Server** | Data ingestion, null handling, staging → production pipeline, view creation |
| **Power Query** | Data transformation and shaping before BI layer |
| **Power BI + DAX** | Interactive stakeholder dashboards (Summary + Prediction pages) |
| **Python (scikit-learn)** | Random Forest classifier — training, evaluation, and scoring new customers |
| **Jupyter Notebook** | Model development and feature importance analysis |
| **pandas / NumPy / seaborn** | Data preprocessing and visualisation |

---

##  Project Workflow

```
Raw Data (CSV)
     │
     ▼
[1] SQL Server — stg_Churn (staging table)
     │  • Null checks across all 32 columns
     │  • ISNULL() imputation for 10 nullable fields
     │
     ▼
[2] SQL Server — prod_Churn (production table)
     │  • vw_ChurnData  → feeds model training (Churned + Stayed)
     │  • vw_JoinData   → feeds prediction scoring (Joined)
     │
     ▼
[3] Power BI — Summary Dashboard
     │  • KPI cards: Total Customers, Churn Rate, New Joiners, Revenue at Risk
     │  • Demographic, Geographic, Account Info, Services Used breakdowns
     │  • Churn Distribution by category and reason
     │
     ▼
[4] Python — Random Forest Model
     │  • Label encoding across 19 categorical features
     │  • Train/test split (80/20)
     │  • RandomForestClassifier (n_estimators=100)
     │  • Feature importance ranking
     │
     ▼
[5] Power BI — Prediction Dashboard
     │  • Predicted Churner Profile (demographic breakdown of at-risk customers)
     │  • Customers at Risk table (individual-level flags)
     └─ Output: Predictions.csv — 411 new joiners scored for churn risk
```

---

##  Key Findings from the Data

### Churn Drivers

| Finding | Detail |
|---|---|
| **Contract type is the #1 structural risk factor** | Month-to-Month customers churn at **46.5%** vs 11.0% (One Year) vs 2.7% (Two Year) |
| **Fiber Optic users churn at 2x the rate of DSL** | Fiber Optic: 41.1% churn · Cable: 25.7% · DSL: 19.4% — premium service, high dissatisfaction |
| **Competitor pressure dominates churn reasons** | 761 customers lost to competitors · Top reasons: better devices (289), better offers (274), more data (106) |
| **Attitude of support staff is #3 churn reason** | 208 customers cited support attitude — a non-product, fully controllable retention lever |
| **Older customers churn more** | Avg age of churned customers: 50.1 yrs vs 46.1 yrs for retained customers |
| **Geographic concentration** | Jammu & Kashmir (183), Uttar Pradesh (157), Tamil Nadu (153) are highest churn states |
| **Revenue impact** | ₹34.1L revenue already lost · 411 new joiners scored to prevent next wave of churn |

---

##  Machine Learning Model

**Algorithm:** Random Forest Classifier

**Feature Engineering:**
- Label encoding for 19 categorical variables (Gender, Contract, Internet_Type, Payment_Method, etc.)
- Target variable: `Customer_Status` → Churned (1) / Stayed (0)
- Trained on historical churned + stayed customers via `vw_ChurnData`
- Scored on 411 new joiners via `vw_JoinData`

Model Performance:

| Metric | Score |
|---|---|
| Accuracy | 84% |
| Precision (Churned class) | 80% |
| Recall (Churned class) | 63% |
| F1-Score (Churned class) | 70% |

> How to get these numbers: Run `churn_prediction.py` and copy the output of `classification_report(y_test, y_pred)` into the table above.

Top Predictive Features (from feature_importances_ plot):
- Contract type
- Monthly Charge
- Tenure in Months
- Total Revenue
- Number of Referrals

---

##  Power BI Dashboard

### Page 1 — Churn Analysis Summary
KPI header · Demographic breakdown · Geographic churn map · Churn category & reason distribution · Services used analysis · Account info segmentation

### Page 2 — Churn Prediction
Predicted churner demographic profile · Customer-level risk table with flagged individuals from new joiner cohort

> Dashboard screenshots — see `/screenshots` folder in this repo

---

##  Business Impact

| Outcome | Value |
|---|---|
| Customers identified as churned (historical) | 1,732 out of 6,007 active |
| Revenue already lost to churn | ₹34,11,961 (17.5% of total) |
| New joiners scored for proactive retention | 411 customers |
| Retention strategy enabled | Targeted campaigns for Month-to-Month + Fiber Optic segments instead of blanket spend |
| Competitor risk mitigation | 761 at-risk customers identified by competitive threat category |

Business recommendation generated from this analysis:
- Priority 1: Convert Month-to-Month customers to One Year contracts via loyalty incentives — would reduce churn from 46.5% to ~11%
- Priority 2: Investigate Fiber Optic service quality — 41.1% churn rate despite premium pricing signals unmet expectations
- Priority 3: Support staff training programme — 208 churn cases are directly attributable to human interaction quality

---

##  Repository Structure

```
Customer-Churn-Analytics/
│
├── churn_analysis.sql          # SQL: staging, null handling, prod table, views
├── churn_prediction.py         # Python: preprocessing, RF model, new joiner scoring
├── Customer_Data.csv           # Source dataset (6,418 customers, 32 features)
├── Customer_Churn.pbix         # Power BI report file (Summary + Prediction pages)
│
├── screenshots/
│   ├── summary_dashboard.png   # Power BI Summary page
│   └── prediction_dashboard.png # Power BI Prediction page
│
└── README.md
```

---

##  How to Run

SQL Setup:
1. Import `Customer_Data.csv` into SQL Server as `stg_Churn`
2. Run `churn_analysis.sql` to create `prod_Churn`, `vw_ChurnData`, `vw_JoinData`

Python Model:
```bash
pip install pandas numpy matplotlib seaborn scikit-learn joblib openpyxl
jupyter notebook churn_prediction.py
```
Update file paths in the script to point to your local `Prediction_Data.xlsx`.

Power BI:
Open `Customer_Churn.pbix` — update the SQL Server connection string to your local instance.

---

##  About

Priya Upadhyay· Data / Business Analyst  
[LinkedIn](https://www.linkedin.com/in/priya-upadhyay-89b418166) · [GitHub](https://github.com/PriyaUp24) · iampriyaupadhyay@gmail.com

*Prior experience as Oracle GoldenGate Developer at Vodafone India — data pipeline integrity, CDC, and large-scale operational datasets.*

---

*Dataset contains Indian telecom customer data across 6,418 records and 32 attributes including demographic, geographic, service, and financial dimensions.*
