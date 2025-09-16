/*
===========================================================
 File:        create_analytics_schema.sql
 Purpose:     Initialize the analytics schema for the project.
 Author:      Amadeo F. Genio IV
 Description: 
   - Contains fact and dimension tables for final analysis.
 Notes:
   - Must be run after the database is created.
   - Make sure to be on the right database (ecommerce_db).
   - Schemas organize tables and help dbt manage sources and models.
============================================================
*/

-- Create the analytics schema
CREATE SCHEMA IF NOT EXISTS analytics;