/*
===========================================================
 File:        create_raw_schema.sql
 Purpose:     Initialize the raw schema for the project.
 Author:      Amadeo F. Genio IV
 Description: 
   - Contains untouched CSV/raw data loaded directly from source.
 Notes:
   - Must be run after the database is created.
   - Make sure to be on the right database (ecommerce_db).
   - Schemas organize tables and help dbt manage sources and models.
============================================================
*/

-- Create the raw schema
CREATE SCHEMA IF NOT EXISTS raw;