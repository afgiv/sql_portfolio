# 🗄️ SQL & Data Engineering Portfolio

Welcome to my SQL & Data Engineering Portfolio! This repository showcases projects where I clean, transform, and analyze datasets, as well as build automated database and dbt modeling workflows.

> **Companion Repository:** Looking for interactive Power BI dashboards, DAX measures, and end-to-end retail reporting? View my **[Power BI & Data Analytics Portfolio (`pbi_portfolio`)](https://github.com/afgiv/pbi_portfolio)**.

---

## 🛠️ Tech Stack
- **Databases & Warehousing:** PostgreSQL, MySQL
- **Transformations & Modeling:** SQL, dbt (Data Build Tool), Star Schema Design
- **Scripting & Automation:** Python (`psycopg2`), Makefile, Git, MinGW

---

## 📂 Projects

### 1. 🧱 [Ecommerce Analytics Pipeline (dbt + PostgreSQL)](./Data%20Engineering/dbt%20project)
- **Dataset:** Ecommerce Transaction Data (`PostgreSQL` + `dbt`)
- **Focus:** Analytics Engineering, Modular SQL Transformations & Data Quality Logging
- **Highlights:**
  - Built a modular **dbt** transformation pipeline (`ecommerce`) backed by **PostgreSQL** to turn raw ecommerce records into analytics-ready models.
  - Automated dataset ingestion (`dataset.py`) and pipeline run/test result logging (`log_results.py`) in Python.
  - Documented data lineage and warehouse architecture in `diagrams/` for clear pipeline traceability.

---

### 2. 📊 [Sales Data Sample (ETL Automation with Makefile)](./Data%20Engineering/Sales%20Data%20Sample)
- **Dataset:** Sales Data Sample (`PostgreSQL`)
- **Focus:** End-to-End ETL Pipeline (Data Engineering + SQL)
- **Highlights:**
  - Designed staging, dimension, and fact tables for a star schema.
  - Automated ETL pipeline using a `Makefile` and Python (`psycopg2`): load staging → clean → dims → fact → semantic views → data quality checks.
  - Ensured repeatable, idempotent execution for resetting or refreshing the database, complete with a setup guide for PostgreSQL, Python, and MinGW.

---

### 3. 🛒 [Superstore — Retail Sales & Margin Scenario Analysis](./Superstore)
- **Dataset:** Global Superstore Sales (2014–2017)
- **Focus:** Data Cleaning & Exploratory Data Analysis (EDA)
- **Highlights:**
  - Cleaned and standardized data (dates, duplicates, calculated Unit Price & Unit Cost).
  - Analyzed sales, profit, yearly trends, and margins across categories, products, and customer segments.
  - Identified loss-making products and modeled business scenarios (discount reduction vs. price increase).

---

### 4. 🌍 [Global Layoffs — Workforce Trend Analysis](./Global%20Layoffs)
- **Dataset:** Worldwide Layoffs (2020–2023)
- **Focus:** Data Cleaning & Trend Analysis
- **Highlights:**
  - Standardized missing values, misspellings, duplicates, and date formatting.
  - Analyzed layoff trends by company, industry, country, and year, including top companies per year and rolling monthly totals.

---

### 5. 🎓 [SQL Fundamentals Reference](./Tutorial)
- **Dataset:** Practice Dataset (Parks and Recreation)
- **Focus:** Core SQL Querying Patterns
- **Highlights:**
  - Reference queries covering filtering, aggregations (`AVG`, `MAX`, `MIN`, `COUNT`), `GROUP BY`, `HAVING`, multi-table joins, and calculated columns.

---

## 💡 Skills Demonstrated
- **Data Modeling & Warehousing:** Star Schema Design, Staging/Intermediate/Analytics Layers, dbt Modular Models
- **SQL & Analytics:** Data Cleaning, Deduplication, Window Functions, Joins, Scenario & Margin Analysis
- **Automation:** Python + PostgreSQL Integration (`psycopg2`), `Makefile` Orchestration, Pipeline Result Logging
