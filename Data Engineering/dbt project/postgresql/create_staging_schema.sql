/*
===========================================================
 File:        create_staging_schema.sql
 Purpose:     Initialize the staging schema for the project.
 Author:      Amadeo F. Genio IV
 Description: 
   - Contains fact and dimension tables for final analysis.
 Notes:
   - Must be run after the database is created.
   - Make sure to be on the right database (ecommerce_db).
   - Schemas organize tables and help dbt manage sources and models.
============================================================
*/

-- Create the staging schema
CREATE SCHEMA IF NOT EXISTS staging;