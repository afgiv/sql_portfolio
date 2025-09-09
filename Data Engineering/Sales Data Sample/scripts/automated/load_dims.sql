/*
===========================================================
 File:        load_dims.sql
 Purpose:     Populate dimension tables from staging data
 Author:      Amadeo F. Genio IV
 Description:
   - Extracts unique records from staging_sales.
   - Standardizes and enriches attributes for dimension tables.
   - Ensures referential integrity for fact table loading.
   - Uses surrogate keys for primary identifiers.
   - Utilizes ON CONFLICT ON CONSTRAINT DO NOTHING for all dims
     loads to handle duplications for future inserts.
 Dimensions Loaded:
   - dim_date
   - dim_geography
   - dim_customer
   - dim_product
   - dim_deal_size
   - dim_status
 Notes:
   - Run only after staging_sales has been cleaned and tables for dims
     are created.
   - After data profiling, appropriate unique constraints are added.
===========================================================
*/

-- 1. Load the dim_date table
-- date_id is SERIAL, auto-generated
INSERT INTO dim_date (order_date, qtr_id, month_id, year_id)
SELECT DISTINCT order_date, qtr_id, month_id, year_id
FROM staging_sales
ON CONFLICT ON CONSTRAINT dim_date_uq DO NOTHING;

-- 2. Load the dim_geography table
-- geo_id is SERIAL, auto-generated
INSERT INTO dim_geography (postal_code, city, state, country, territory)
SELECT DISTINCT postal_code, city, state, country, territory
FROM staging_sales
ON CONFLICT ON CONSTRAINT dim_geo_uq DO NOTHING;

-- 3. Load the dim_customer table
-- geo_id is pulled from the dim_geography table to preserve FK relationship
-- customer_id is SERIAL, auto-generated
INSERT INTO dim_customer (company_name, customer_firstname, customer_lastname,
phone, address_1, address_2, geo_id)
SELECT DISTINCT c.company_name, c.customer_firstname, c.customer_lastname, c.phone,
c.address_1, c.address_2, g.geo_id
FROM staging_sales AS c
LEFT JOIN dim_geography AS g
	ON c.city = g.city
	AND c.state = g.state
	AND c.country = g.country
	AND c.territory = g.territory
ON CONFLICT ON CONSTRAINT dim_cust_uq DO NOTHING;

-- 4.Load the dim_product table
-- product_id is SERIAL, auto-generated
INSERT INTO dim_product (product_code, product_line, msrp)
SELECT DISTINCT product_code, product_line, msrp
FROM staging_sales
ON CONFLICT ON CONSTRAINT dim_prod_uq DO NOTHING;

-- 5. Load the dim_deal_size table
-- size_id is SERIAL, auto-generated
INSERT INTO dim_deal_size (deal_size)
SELECT DISTINCT deal_size
FROM staging_sales
ON CONFLICT ON CONSTRAINT dim_deal_uq DO NOTHING;

-- 6. Load the dim_status table
-- status_id is SERIAL, auto-generated
INSERT INTO dim_status (status)
SELECT DISTINCT status
FROM staging_sales
ON CONFLICT ON CONSTRAINT dim_status_uq DO NOTHING;