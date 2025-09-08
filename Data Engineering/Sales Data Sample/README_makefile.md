📘 Makefile Usage Guide

📌 Overview

This Makefile automates the setup and refresh of the Sales Data Sample ETL pipeline.

It covers:

Infrastructure (database, dimensions, fact, staging)

Automated ETL (load staging → cleaning → dims → fact → views → quality checks)

Designed for repeatable and idempotent execution — so you can easily reset or refresh the pipeline.

⚙️ Prerequisites

PostgreSQL installed and psql available in PATH

Python 3 installed (for loading staging data)

.env file configured with database details

📝 Environment Variables

An .env.example file is provided. Run this command on Git Bash:

cp .env.example .env

Open the .env file with text editor and update with your values.

🔒 Note: The database password is not stored in .env. You will be prompted when running commands.

🚀 Commands (Git Bash)
1. Infrastructure Setup (run once)

Creates database and schema objects.

make infra

Equivalent to running:

make create_database → Drops & recreates the database

make create_dims → Creates dimension tables

make create_fact → Creates fact table

make create_staging → Creates staging table

2. Automated ETL Pipeline (run repeatedly)

Runs the full transformation pipeline:

make automated

Steps executed:

make load_staging → Load raw data into the staging table

make cleaning → Cleans staging data

make dims → Loads dimension tables

make fact → Loads fact table

make qc_fact → Runs fact-level data quality checks

make views → Creates semantic/reporting views

make qc_views → Runs view-level data quality checks

3. Run Individual Targets

You can also run steps individually:

make cleaning
make dims
make fact
make qc_views

🧹 Resetting the Database

To rebuild from scratch:

make create_database
make infra


✅ With this setup, contributors can reproduce your pipeline simply by configuring their .env and running:

make infra
make automated