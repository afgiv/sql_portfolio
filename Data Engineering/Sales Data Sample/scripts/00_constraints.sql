/*
===========================================================
File:        00_constraints.sql
Purpose:     Add additional constraints or unique indexes
Author:      Amadeo F. Genio IV
Description:
  - Adds unique constraints or indexes discovered after data profiling.
  - Ensures natural keys are enforced in production.
  - Run manually once after the dims have been loaded to avoid conflicts with ETL scripts.
Notes:
  - Columns chosen for unique constraints are determined by comparing the total row count
    with the total count of distinct values for the selected columns. 
    If the counts match, the combination is considered a natural key.
  - All columns for dim_geography were chosen since postal_code is not globally unique.
===========================================================
*/

-- 1. Create unique constraint for dim_geography to avoid duplication for future inserts
ALTER TABLE dim_geography
ADD CONSTRAINT dim_geo_uq UNIQUE (postal_code, city, state, country, territory);

-- 2.  Create unique constraint for dim_customer to avoid duplication for future inserts
ALTER TABLE dim_customer
ADD CONSTRAINT dim_cust_uq UNIQUE (company_name, customer_firstname, customer_lastname);