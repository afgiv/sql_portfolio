/*
===========================================================
 File:        05_data_cleaning.sql
 Purpose:     Clean and transform data in the staging table
 Author:      Amadeo F. Genio IV
 Description:
   - Removes duplicates (if any) and handles null or invalid values.
   - Normalizes categorical fields (e.g., country, territory).
   - Recalculated price column as the prices are capped to 100 (as per the source)
   - Prepares cleaned data for loading into dimension
     and fact tables.
 Notes:
   - Cleaning ensures consistency and reliability of data.
   - Run this script after loading data into staging_sales.
===========================================================
*/

-- Check the table if the loading process from the python script was successful
SELECT *
FROM staging_sales;

-- Describe the Staging Table
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'staging_sales'
ORDER BY ordinal_position;

-- Check for NULL values (important ones)
SELECT *
FROM staging_sales
WHERE order_number IS NULL OR quantity IS NULL OR price IS NULL OR order_line_num IS NULL OR order_date IS NULL OR
status IS NULL OR qtr_id IS NULL OR month_id IS NULL OR year_id IS NULL OR product_line IS NULL OR msrp IS NULL OR
product_code IS NULL OR company_name IS NULL OR phone IS NULL OR address_1 IS NULL OR city IS NULL
OR country IS NULL OR territory IS NULL OR customer_firstname IS NULL OR customer_lastname IS NULL OR deal_size IS NULL;
-- No NULL values for these columns meaning only the state column and address_2 have NULLs

-- Check for Duplicates
SELECT order_number, quantity, price, order_line_num, order_date, status, qtr_id, month_id, year_id, product_line, msrp,
product_code, company_name, phone, address_1, address_2, city, state, postal_code, country, territory, customer_firstname,
customer_lastname, deal_size, COUNT(*) AS dup_count
FROM staging_sales
GROUP BY order_number, quantity, price, order_line_num, order_date, status, qtr_id, month_id, year_id, product_line, msrp,
product_code, company_name, phone, address_1, address_2, city, state, postal_code, country, territory, customer_firstname,
customer_lastname, deal_size
HAVING COUNT(*) > 1;
-- No duplicates found

-- Check categorical fields for misspells, whitespaces
SELECT DISTINCT status
FROM staging_sales;

SELECT DISTINCT product_line
FROM staging_sales;

SELECT DISTINCT company_name
FROM staging_sales
ORDER BY company_name;

SELECT DISTINCT city
FROM staging_sales
ORDER BY city;

SELECT DISTINCT state
FROM staging_sales
ORDER BY state; 

SELECT DISTINCT postal_code
FROM staging_sales;

SELECT DISTINCT country
FROM staging_sales
ORDER BY country; 

SELECT DISTINCT territory
FROM staging_sales; 

SELECT DISTINCT deal_size
FROM staging_sales;

-- Standardize the columns state, country, and territory by expanding the abbreviations
UPDATE staging_sales
SET state = CASE
	WHEN state = 'BC' THEN 'British Columbia'
	WHEN state = 'CA' THEN 'California'
	WHEN state = 'CT' THEN 'Connecticut'
	WHEN state = 'MA' THEN 'Massachusetts'
	WHEN state = 'NH' THEN 'New Hampshire'
	WHEN state = 'NJ' THEN 'New Jersey'
	WHEN state = 'NSW' THEN 'New South Wales'
	WHEN state = 'NV' THEN 'Nevada'
	WHEN state = 'NY' THEN 'New York'
	WHEN state = 'PA' THEN 'Pennsylvania'
	ELSE state
END;

UPDATE staging_sales
SET country = CASE
	WHEN country = 'UK' THEN 'United Kingdom'
	WHEN country = 'USA' THEN 'United States'
	ELSE country
END;

UPDATE staging_sales
SET territory = CASE
	WHEN territory = 'APAC' THEN 'Asia-Pacific'
	WHEN territory = 'EMEA' THEN 'Europe, Middle East, Africa'
	WHEN territory = 'NA' THEN 'North America'
	ELSE territory
END;

-- Check the phone numbers and standardize them by leaving only the digits
SELECT DISTINCT phone
FROM staging_sales;

UPDATE staging_sales
SET phone = REGEXP_REPLACE(phone, '[^\d]', '', 'g');

-- Check phone numbers that might be corrupted
SELECT DISTINCT phone
FROM staging_sales
WHERE LENGTH(phone) < 7 OR LENGTH(phone) > 15;

-- Fill NULLs on the state column with 'N/A'
UPDATE staging_sales
SET state = 'N/A'
WHERE state IS NULL;

-- Recalculate price column where price are capped to 100
UPDATE staging_sales
SET price = sales / quantity
WHERE price = 100 AND sales / quantity != 100;

-- Recalculate sales column using the recalculated price column
UPDATE staging_sales
SET sales = price * quantity;