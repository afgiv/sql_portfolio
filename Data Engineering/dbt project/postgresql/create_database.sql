/*
===========================================================
 File:        create_database.sql
 Purpose:     Initialize the project database.
 Author:      Amadeo F. Genio IV
 Description: 
   - Creates a fresh database for the project
 Notes:
	- Have to be run manually for dbt to read.
	- Run this script first after checking the raw data
	  in Python.
============================================================
*/

-- 1. Create the Database
CREATE DATABASE ecommerce_db;