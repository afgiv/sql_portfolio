📘 Makefile Usage Guide

📌 Overview

This Makefile automates the setup and refresh of the Sales Data Sample ETL pipeline.

It covers:

Infrastructure: database, dimensions, fact, staging tables

Automated ETL: load staging → cleaning → dims → fact → views → quality checks

The design ensures repeatable and idempotent execution — making it easy to reset or refresh the pipeline anytime.

⚙️ Prerequisites

PostgreSQL installed, with psql available in PATH

Python 3 installed (for loading staging data)

Use python3 on Linux/Mac

Use python on Windows

GNU Make installed

On Windows, run commands from Git Bash (ships with Git)

A configured .env file (see below)

📝 Environment Variables

An .env.example file is provided.

Create your own .env file by running in Git Bash:

cp .env.example .env


Then edit .env with your database details:

DB_USER=your_username

DB_NAME=sales_db


🔒 Note: The database password is not stored in .env. You will be prompted at runtime.

🚀 Commands

🔒 Always run commands from the root folder in Git Bash.

1. Infrastructure Setup (run once)

Creates the database and schema objects.

make infra


Equivalent to running:

make create_database → ⚠️ Drops & recreates the database

make create_dims → Creates dimension tables

make create_fact → Creates fact table

make create_staging → Creates staging table

2. Automated ETL Pipeline (run repeatedly)

Runs the full ETL pipeline end-to-end.

make automated


Steps executed:

make load_staging → Load raw data into the staging table

make cleaning → Clean staging data

make dims → Load dimension tables

make fact → Load fact table

make qc_fact → Run fact-level data quality checks

make views → Create semantic/reporting views

make qc_views → Run view-level data quality checks

3. Run Individual Targets

Each step can also be run independently:

make cleaning
make dims
make fact
make qc_views

🧹 Resetting the Database

To rebuild from scratch:

make create_database
make infra

⚠️ This will DROP and recreate the database.