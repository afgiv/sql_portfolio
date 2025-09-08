/*
===========================================================
 File:        qc_views.sql
 Purpose:     Data quality checks for semantic views
 Author:      Amadeo F. Genio IV
 Description:
   - Validates correctness and consistency of reporting views.
   - Ensures aggregated results in views reconcile with base 
     fact and dimension tables.
   - Detects potential data leakage or mismatches in joins.
 Checks Included:
   - Row count consistency between vw_sales_detail and fact_sales.
   - Aggregate totals in views (year, company, product, country,
     territory, deal size) match corresponding fact_sales sums.
   - Top-N validation of companies to ensure ranking 
     logic is correct.
 Notes:
   - These checks are **read-only** and should not modify data.
   - Designed for analyst and engineer validation before BI 
     consumption.
   - Extendable: new views should include parallel checks here.
===========================================================
*/

-- 1. Row count via fact_sales vs vw_sales_detail
SELECT 
	(SELECT COUNT(*) FROM fact_sales) AS fact_count,
	(SELECT COUNT(*) FROM vw_sales_detail) AS view_count,
	(SELECT COUNT(*) FROM fact_sales) - (SELECT COUNT(*) FROM vw_sales_detail) AS diff_count;

-- 2. Sum totals of sales and profit of fact_table vs views

-- Year view
SELECT SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_date AS d
	ON f.order_date = d.order_date
GROUP BY d.year_id
ORDER BY d.year_id DESC;

SELECT total_sales, total_profit
FROM vw_sales_year;

-- Company view
SELECT SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_customer AS c
	ON f.customer_id = c.customer_id
GROUP BY c.company_name
ORDER BY total_sales DESC, total_profit DESC
LIMIT 10;

SELECT total_sales, total_profit
FROM vw_sales_company;

-- Product Line view
SELECT SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_product AS p
	ON f.product_code = p.product_code
GROUP BY p.product_line
ORDER BY total_sales DESC, total_profit DESC;

SELECT total_sales, total_profit
FROM vw_sales_product;

-- Country view
SELECT SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_customer AS c
	ON f.customer_id = c.customer_id
JOIN dim_geography AS g
	ON c.geo_id = g.geo_id
GROUP BY g.country
ORDER BY total_sales DESC, total_profit DESC;

SELECT total_sales, total_profit
FROM vw_sales_country;

-- Territory view
SELECT SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_customer AS c
	ON f.customer_id = c.customer_id
JOIN dim_geography AS g
	ON c.geo_id = g.geo_id
GROUP BY g.territory
ORDER BY total_sales DESC, total_profit DESC;

SELECT total_sales, total_profit
FROM vw_sales_territory;

-- Deal size
SELECT SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_order AS o
	ON f.order_number = o.order_number
GROUP BY o.deal_size
ORDER BY total_sales DESC, total_profit DESC;

SELECT total_sales, total_profit
FROM vw_sales_deal_size;

-- 3. Top 10 Count validation for vw_sales_company
SELECT COUNT(*)
FROM vw_sales_company;