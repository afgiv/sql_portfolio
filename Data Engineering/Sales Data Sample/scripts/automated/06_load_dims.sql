/*
===========================================================
 File:        06_load_dims.sql
 Purpose:     Populate dimension tables from staging data
 Author:      Amadeo F. Genio IV
 Description:
   - Extracts unique records from staging_sales.
   - Standardizes and enriches attributes for dimension tables.
   - Ensures referential integrity for fact table loading.
   - Uses surrogate keys for primary identifiers.
   - Applies a unique index on dim_geography (with COALESCE on
     nullable columns) to prevent duplicates.
   - Utilizes ON CONFLICT ON CONSTRAINT DO NOTHING for dim_geography
     and dim_customer loads to handle natural key collisions gracefully.
 Dimensions Loaded:
   - dim_date
   - dim_geography
   - dim_customer
   - dim_product
   - dim_order
 Notes:
   - Run only after staging_sales has been cleaned.
   - Dimension tables are initially loaded without unique constraints
     to avoid ETL conflicts.
   - After data profiling, appropriate unique constraints are added.
   - The `ON CONFLICT ON CONSTRAINT` clause is then applied in
     subsequent loads to ensure no duplicate rows are inserted while
     preserving referential integrity.
   - Designed to be repeatable and idempotent if TRUNCATE is
     applied before load.
===========================================================
*/

-- 1. Load the dim_date table
INSERT INTO dim_date (order_date, qtr_id, month_id, year_id)
SELECT DISTINCT order_date, qtr_id, month_id, year_id
FROM staging_sales
ON CONFLICT (order_date) DO NOTHING;

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
INSERT INTO dim_product (product_code, product_line, msrp)
SELECT DISTINCT product_code, product_line, msrp
FROM staging_sales
ON CONFLICT (product_code) DO NOTHING;

-- 5. Load the dim_order table
INSERT INTO dim_order (order_number, deal_size)
SELECT DISTINCT order_number, deal_size
FROM staging_sales
ON CONFLICT (order_number) DO NOTHING;