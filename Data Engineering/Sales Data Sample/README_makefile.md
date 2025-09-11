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

DB_PASSWORD=your_password


🔒 Note: The database password is not stored in .env. You will be prompted at runtime.

🚀 Commands

🔒 Always run commands from the root folder in Git Bash.

0. Setup PATH (Windows only)

Before running commands, ensure Git Bash can see GNU Make and Python.

Run this in Git Bash:

export PATH=$PATH:/c/MinGW/bin:/c/Users/MSI/AppData/Local/Programs/Python/Python313


To verify:

mingw32-make --version
python --version


If both show version numbers, setup is correct.

⚠️ If you still see Python was not found, disable the App Execution Aliases for Python:
Settings → Apps → Advanced app settings → App execution aliases → turn off python.exe and python3.exe.


1. Infrastructure Setup (run once)

Creates the database and schema objects.

mingw32-make infra


Equivalent to running:

mingw32-make create_database → ⚠️ Drops & recreates the database

mingw32-make create_dims → Creates dimension tables

mingw32-make create_fact → Creates fact table

mingw32-make create_staging → Creates staging table


2. Automated ETL Pipeline (run repeatedly)

Runs the full ETL pipeline end-to-end.

mingw-32-make automated


Steps executed:

mingw32-make load_staging → Load raw data into the staging table

mingw32-make cleaning → Clean staging data

mingw32-make dims → Load dimension tables

mingw32-make fact → Load fact table

mingw32-make qc_fact → Run fact-level data quality checks

mingw32-make views → Create semantic/reporting views

mingw32-make qc_views → Run view-level data quality checks

3. Run Individual Targets

Each step can also be run independently:

mingw-32-make cleaning
mingw-32-make dims
mingw-32-make fact
mingw-32-make qc_views

🧹 Resetting the Database

To rebuild from scratch:

mingw-32-make infra

⚠️ This will DROP and recreate the database.