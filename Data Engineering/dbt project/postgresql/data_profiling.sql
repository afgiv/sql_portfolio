SELECT * FROM staging_to_intermediate.int_full_table;

SELECT COUNT(*) FROM staging_to_intermediate.int_full_table;
-- Total Row Count: 112250

-- Check relationship between cities and states for customer, seller, and geolocation
SELECT customer_city, geo_c_city, customer_state, geo_c_city,
seller_city, geo_s_city, seller_state, geo_s_state
FROM staging_to_intermediate.int_full_table
-- Only shows redundancy, can be removed in the dims

-- Grain check
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT order_id) AS grain_count
FROM staging_to_intermediate.int_full_table;
-- 112250 vs 98312
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT (order_id, order_item_num)) AS grain_count
FROM staging_to_intermediate.int_full_table;
-- 112250 vs 112250
-- Result: Matching row count
-- Action: order_id + order_item_num are the composite keys for the fact table

-- Cardinality check

-- Fact table
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT product_id) AS unique_values,
ROUND((CAST(COUNT(DISTINCT product_id) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 29.35% of uniqueness
-- Action: product_id is a dimension key

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT seller_id) AS unique_values,
ROUND((CAST(COUNT(DISTINCT seller_id) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 2.76% of uniqueness
-- Action: seller_id is a dimension key (seller_id is an entity)

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT expected_shipping_date) AS unique_values,
ROUND((CAST(COUNT(DISTINCT expected_shipping_date) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 82.89% of uniqueness
-- Action: expected_shipping_date is a potential dimension key for another table

-- Customer dimension
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT customer_id) AS unique_values,
ROUND((CAST(COUNT(DISTINCT customer_id) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 87.58%
-- Action: customer_id is a potential dimension key

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT customer_unique_id) AS unique_values,
ROUND((CAST(COUNT(DISTINCT customer_unique_id) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 84.46%
-- Action: customer_unique_id is a potential dimension key

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT customer_zip_code) AS unique_values,
ROUND((CAST(COUNT(DISTINCT customer_zip_code) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 13.19%
-- Action: customer_zip_code is a potential dimension key

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT customer_city) AS unique_values,
ROUND((CAST(COUNT(DISTINCT customer_city) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 3.62%
-- Action: customer_city is a potential dimension attribute for another table

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT customer_state) AS unique_values,
ROUND((CAST(COUNT(DISTINCT customer_state) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 0.02%
-- Action: customer_state is a potential dimension attribute for another table

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT geo_c_city) AS unique_values,
ROUND((CAST(COUNT(DISTINCT geo_c_city) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 3.59%
-- Action: customer_state is a potential dimension attribute for another table

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT geo_c_state) AS unique_values,
ROUND((CAST(COUNT(DISTINCT geo_c_state) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;


-- Seller Dimension
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT seller_zip_code) AS unique_values,
ROUND((CAST(COUNT(DISTINCT seller_zip_code) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 1.99%
-- Action: seller_zip_code is a potential dimension attribute for another table

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT seller_city) AS unique_values,
ROUND((CAST(COUNT(DISTINCT seller_city) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 0.54%
-- Action: seller_city is a potential dimension attribute for another table

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT seller_state) AS unique_values,
ROUND((CAST(COUNT(DISTINCT seller_state) AS NUMERIC)/COUNT(*)) * 100, 2) AS unique_pct
FROM staging_to_intermediate.int_full_table;
-- Result: 0.02%
-- Action: seller_state is a potential dimension attribute for another table

-- Product Category