/*
===========================================================
 File:        08_quality_checks.sql
 Purpose:     Validate integrity and consistency of fact_sales
 Author:      Amadeo F. Genio IV
 Description:
   - Performs automated quality checks on the fact_sales table
     after ETL load.
   - Ensures referential integrity, uniqueness, and accuracy 
     of business measures.
   - Identifies anomalies such as orphaned records, duplicates,
     or inconsistent calculations.
 Checks Performed:
   - Row count reconciliation with staging data
   - Foreign key integrity against dimension tables
   - Uniqueness of composite primary key (order_number + order_line_num)
   - Consistency of derived measures (e.g., sales = price * quantity,
     profit = sales - cost)
   - Validation of data ranges and absence of invalid NULL values
   - Aggregate comparisons between fact and staging
 Notes:
   - Designed for repeatable execution after each ETL run.
   - Does not modify data — read-only validation queries.
===========================================================
*/

-- 1. Row count via staging_sales vs fact_sales
SELECT
	(SELECT COUNT(*) FROM staging_sales) AS staging_count,
	(SELECT COUNT(*) FROM fact_sales) AS fact_count,
	(SELECT COUNT(*) FROM staging_sales) - (SELECT COUNT(*) FROM fact_sales) AS diff_count;

-- 2. Check foreign key integrity against dimension tables
SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS check_status
FROM fact_sales AS f
LEFT JOIN dim_customer AS c
	ON f.customer_id = c.customer_id
LEFT JOIN dim_order AS o
	ON f.order_number = o.order_number
LEFT JOIN dim_product AS p
	ON f.product_code = p.product_code
LEFT JOIN dim_date AS d
	ON f.order_date = d.order_date
WHERE c.customer_id IS NULL
	OR o.order_number IS NULL
	OR p.product_code IS NULL
	OR d.order_date IS NULL;

SELECT *
FROM dim_customer AS c
LEFT JOIN dim_geography AS g
	ON c.geo_id = g.geo_id
WHERE g.geo_id IS NULL;

-- 3. Uniqueness of composite primary key of fact_sales table
SELECT order_number, order_line_num, COUNT(*) AS dupes
FROM fact_sales
GROUP BY order_number, order_line_num
HAVING COUNT(*) > 1;

-- 4. Consistency of derived measures
SELECT sales
FROM fact_sales
WHERE sales != price * quantity;

SELECT profit
FROM fact_sales
WHERE profit != sales - (cost * quantity);

-- 5. Validation of data ranges
SELECT cost, quantity, price, sales, profit
FROM fact_sales
WHERE cost < 0 OR quantity < 0 OR price < 0 OR profit < 0;

-- 6. NULL check on key fields
SELECT order_number, order_line_num, product_code, customer_id, order_date
FROM fact_sales
WHERE order_number IS NULL
	OR order_line_num IS NULL
	OR product_code IS NULL
	OR order_date IS NULL;

-- 7. Aggregate functions comparison
SELECT d.year_id, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_date AS d
	ON f.order_date = d.order_date
GROUP BY d.year_id
ORDER BY d.year_id DESC;

SELECT year_id, SUM(sales - (ROUND(price * 0.7, 2) * quantity)) AS total_profit
FROM staging_sales
GROUP BY year_id
ORDER BY year_id DESC;

SELECT c.company_name, SUM(f.sales) AS total_sales
FROM fact_sales AS f
JOIN dim_customer AS c
	ON f.customer_id = c.customer_id
GROUP BY c.company_name
ORDER BY total_sales DESC;

SELECT company_name, SUM(sales) AS total_sales
FROM staging_sales
GROUP BY company_name
ORDER BY total_sales DESC;