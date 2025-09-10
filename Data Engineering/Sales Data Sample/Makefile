# ===========================================================
# File:        Makefile
# Purpose:     Automate database setup and ETL pipeline refresh
# Author:      Amadeo F. Genio IV
# Description:
#   - Provides reproducible commands for setting up the
#     database schema (infrastructure) and running the ETL
#     automation
#     (staging → cleaning → dims → fact → views → quality checks).
#   - Uses environment variables from `.env` for DB_USER and
#     DB_NAME. Password is not stored; users will be prompted.
#   - Designed to simplify execution for both first-time setup
#     and repeated refreshes of the pipeline.
#
# Targets:
#   Infra (run once):
#     - infra            Run full infrastructure setup
#     - create_database  Create the database
#     - create_dims      Create dimension tables
#     - create_fact      Create fact table
#     - create_staging   Create staging table
#
#   Automation (run repeatedly):
#     - automated      Run full ETL pipeline
#                      (staging → cleaning → dims → fact → views → QC)
#     - staging        Load the raw data to the staging table
#     - cleaning       Data cleaning of the raw staging table
#     - dims           Populate dim tables
#     - fact           Populate fact tables
#     - qc_fact        Run data quality checks for fact table
#     - views          Create semantic/reporting views
#     - qc_views       Run data quality checks for views
#
# Usage:
#   make <target>
#   Example: make automated
#
# Notes:
#   - Keep `.env` file private and excluded via .gitignore.
#   - An `.env.example` file is provided; copy and rename it to
#     `.env` and fill in your own database values.
#   - This Makefile is cross-platform as long as `psql` is
#     installed and in PATH.
# ===========================================================


#Load the environmental variables
include .env
export $(shell sed 's/=.*//' .env)

#Connection string (password prompt)
PSQL = psql -U $(DB_USER) -d $(DB_NAME)

# ------------------------------------------------------------
# Infrastructure targets
# ------------------------------------------------------------

infra: create_database create_dims create_fact create_staging

# create_database is a DROP-CREATE for refresh so it needs to connect to other database to work
create_database:
    psql -U $(DB_USER) -d postgres -f scripts/infrastructure/create_database.sql

create_dims:
    $(PSQL) -f scripts/infrastructure/create_dims.sql

create_fact:
    $(PSQL) -f scripts/infrastructure/create_fact.sql

create_staging:
    $(PSQL) -f scripts/infrastructure/create_staging.sql

# ------------------------------------------------------------
# Automated targets
# ------------------------------------------------------------

automated: load_staging cleaning dims fact qc_fact views qc_views

load_staging:
    python scripts/automated/load_staging.py

cleaning:
    $(PSQL) -f scripts/support/data_cleaning.sql

dims:
    $(PSQL) -f scripts/automated/load_dims.sql

fact:
    $(PSQL) -f scripts/automated/load_fact.sql

qc_fact:
    $(PSQL) -f scripts/automated/qc_fact.sql

views:
    $(PSQL) -f scripts/automated/views.sql

qc_views:
    $(PSQL) -f scripts/automated/qc_views.sql