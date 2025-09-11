SQL Portfolio

Welcome to my SQL & Data Engineering Portfolio! 🚀
This repository showcases projects where I clean, transform, and analyze datasets, as well as build data engineering pipelines to automate database workflows.
Each folder contains SQL scripts or automation pipelines highlighting different aspects of data analysis and engineering.

🛠 Tech Stack

Databases: PostgreSQL, MySQL
Languages: SQL, Python
Tools: Power BI, Tableau, Excel, Git, Makefile, MinGW

📂 Projects
1. 📊 Sales Data Sample (ETL Automation with Makefile)
Dataset: Sales Data Sample (PostgreSQL)
Focus: End-to-End ETL Pipeline (Data Engineering + SQL)
Highlights:
Designed staging, dimension, and fact tables for a star schema
Automated ETL pipeline using a Makefile and Python (psycopg2)
Steps: load staging → clean → dims → fact → semantic views → data quality checks
Makefile ensures repeatable, idempotent execution for resetting or refreshing the database
Includes a usage guide with setup instructions for PostgreSQL, Python, and MinGW

2. 🛒 Superstore
Dataset: Global Superstore sales (2014–2017)
Focus: Data Cleaning & Exploratory Data Analysis (EDA)
Highlights:
Cleaned and standardized data (dates, duplicates, calculated Unit Price & Unit Cost)
Sales, profit, yearly trend, and margin analysis by category, product, and customer segments
Identified loss-making products & tested business scenarios (discount reduction, price increase)

3. 🌍 Global Layoffs

Dataset: Worldwide layoffs (2020–2023)
Focus: Data Cleaning & Trend Analysis
Highlights:
Handled missing values, misspellings, duplicates, and date formatting
Layoff trends by company, industry, country, and year
Top companies per year with highest layoffs
Rolling monthly totals to track global workforce reductions

4. 🎓 Tutorial

Dataset: Practice data (Parks and Recreation)
Focus: SQL Fundamentals
Highlights:
Filtering, grouping, and aggregations (AVG, MAX, MIN, COUNT)
Using GROUP BY, HAVING, and ORDER BY
Joins across employee demographics and salary tables
Sorting, limiting results, and calculated columns

🛠 Skills Demonstrated
Data Cleaning & Preprocessing
Exploratory Data Analysis (EDA)
Aggregations, Joins & Window Functions
Scenario Analysis & Business Insights
ETL Automation with Makefile
PostgreSQL Schema Design (Star Schema)
Python + SQL Integration

📌 How to Use
Clone the repository to explore the projects:
git clone https://github.com/afgiv/sql_portfolio.git
