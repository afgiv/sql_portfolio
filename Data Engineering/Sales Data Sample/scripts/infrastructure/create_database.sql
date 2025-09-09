/*
===========================================================
 File:        create_database.sql
 Purpose:     Initialize the project database.
 Author:      Amadeo F. Genio IV
 Description: 
   - Drops the database if it already exists
   - Creates a fresh database for the project
 Notes:
  - Cannot be executed as a script.
  - Run on Git Bash: psql -d postgres -f "full/path/to/create_database.sql"
  - Must be executed against an existing DB (like 'postgres'),
     not inside the target DB itself.
  - Queries can be executed separately.
============================================================
*/

-- Drop the database if it already exists
DROP DATABASE IF EXISTS sales_db;

-- Create a fresh new database
CREATE DATABASE sales_db;