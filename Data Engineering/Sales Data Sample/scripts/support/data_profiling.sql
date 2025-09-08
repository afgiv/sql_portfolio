/*
===========================================================
 File:        data_profiling.sql
 Purpose:     Data profiling checks for key validation
 Author:      Amadeo F. Genio IV
 Description:
   - Confirms uniqueness and grain of fact table keys
     after staging transformations.
   - Validates uniqueness of dimension natural keys.
   - Detects nulls and duplicates that may violate schema.
 Checks Included:
   - Fact table key validation:
       * COUNT(*) vs COUNT(DISTINCT composite PK)
   - Dimension uniqueness validation:
       * product_code, order_date
 Notes:
   - Run data profiling **after staging transformations**.
===========================================================
*/

-----------------------------------------------------------
-- Fact Profiling
-----------------------------------------------------------

-- Use order_number as PK
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT order_number) AS distinct_count
FROM staging_sales;
-- 2823 vs 307

-- Use order_number and order_line_num as composite keys
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT (order_number, order_line_num)) AS distinct_count
FROM staging_sales;
-- Result: matching row count
-- Action: order_number and order_line_num as composite keys

----------------------------------------------------------
-- Dims Profiling
----------------------------------------------------------

-- dim_customer
-- Use company_name as PK
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT company_name) AS distinct_count
FROM staging_sales;
-- 2823 vs 92

-- Use company_name and customer_firstname as composite keys
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT (company_name, customer_firstname)) AS distinct_count
FROM staging_sales;
-- 2823 vs 92

-- Use company_name, customer_firstname and customer_lastname as composite keys
SELECT COUNT(*) AS total_rows,
COUNT(DISTINCT (company_name, customer_firstname, customer_lastname)) AS distinct_count
FROM staging_sales;
-- 2823 vs 92

-- Use company_name, customer_firstname, customer_lastname, and address_1 as composite keys
SELECT COUNT(*) AS total_rows,
COUNT(DISTINCT (company_name, customer_firstname, customer_lastname, address_1)) AS distinct_count
FROM staging_sales;
-- 2823 vs 92

-- Result: No unique combinations found to match total rows
-- Action: dim_customer to have surrogate serial key as primary key

-- dim_date
-- Use order_date as PK
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT order_date) AS distinct_count
FROM staging_sales;
-- 2823 vs 252

-- Use order_date and qtr_id as composite keys
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT (order_date, qtr_id)) AS distinct_count
FROM staging_sales;
-- 2823 vs 252

-- Use order_date, qtr_id, and month_id as composite keys
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT (order_date, qtr_id, month_id)) AS distinct_count
FROM staging_sales;
-- 2823 vs 252

-- Use order_qtr_id, month_id, and year_id as composite keys
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT (order_date, qtr_id, month_id, year_id)) AS distinct_count
FROM staging_sales;
-- 2823 vs 252

-- Result: No unique combinations found to match total rows
-- Action: dim_date to have surrogate serial key as primary key

-- dim_geography
-- Use postal_code as primary key
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT postal_code) AS distinct_count
FROM staging_sales;
-- 2823 vs 73

-- Use postal_code and city as composite keys
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT (postal_code, city)) AS distinct_count
FROM staging_sales;
-- 2823 vs 79

-- Use postal_code, city, and state as composite keys
SELECT COUNt(*) AS total_rows, COUNT(DISTINCT (postal_code, city, state)) AS distinct_count
FROM staging_sales;
-- 2823 vs 79

-- Use postal_code, city, state, and country as composite keys
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT (postal_code, city, state, country)) AS distinct_count
FROM staging_sales;
-- 2823 vs 79

-- Use postal_code, city, state, country, and territory as composite keys
SELECT COUNT(*) AS total_rows,
COUNT(DISTINCT (postal_code, city, state, country, territory)) AS distinct_count
FROM staging_sales;
-- 2823 vs 79

-- Result: No unique combinations found to match total rows
-- Action: dim_geography to have surrogate serial key as primary key

-- dim_order
-- Use order_number as primary key
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT order_number) AS distinct_count
FROM staging_sales;
-- 2823 vs 307

-- Use order_number and deal_size as composite keys
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT (order_number, deal_size)) AS distinct_count
FROM staging_sales;
-- 2823 vs 698

-- Result: No unique combinations found to match total rows
-- Action: dim_order to have surrogate serial key as primary key

-- dim_product
-- Use product_code as primary key
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT product_code) AS distinct_count
FROM staging_sales;
-- 2823 vs 109

-- Use product_code and product_line as composite keys
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT (product_code, product_line)) AS distinct_count
FROM staging_sales;
-- 2823 vs 109

-- Use product_code, product_line, and msrp as composite keys
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT (product_code, product_line, msrp)) AS distinct_count
FROM staging_sales;
-- 2823 vs 109

-- Result: No unique combinations found to match total rows
-- Action: dim_product to have surrogate serial key as primary key