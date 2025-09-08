/*
===========================================================
 File:        create_database.sql
 Purpose:     Initialize the project database.
 Author:      Amadeo F. Genio IV
 Description: 
   - Drops the database if it already exists
   - Creates a fresh database for the project
 Notes:
   - Run this file before any other SQL scripts.
   - This ensures a clean environment every time.
=======
*/

-- Drop the database if it already exists
DROP DATABASE IF EXISTS sales_db;

-- Create a fresh new database
CREATE DATABASE sales_db;