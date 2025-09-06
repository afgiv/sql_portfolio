/*
===========================================================
 File:        09_views.sql
 Purpose:     Create semantic views for analytics and reporting
 Author:      Amadeo F. Genio IV
 Description:
   - Defines business-friendly views on top of the fact_sales 
     and dimension tables.
   - Simplifies complex joins for analysts and BI tools.
   - Provides reusable query patterns for common business 
     questions (e.g., sales by geography, profit by year).
   - Abstracts away surrogate keys and technical fields.
 Views Included:
   - vw_sales_detail    (transaction-level enriched view)
   - vw_sales_year      (aggregated by year)
   - vw_sales_company  (aggregated by company)
   - vw_sales_product   (aggregated by product line)
   - vw_sales_country   (aggregated by country)
   - vw_sales_territory (aggregated by territory)
   - vw_sales_deal_size (aggregated by deal size)
 Notes:
   - Views are read-only and should not be updated directly.
   - Designed to shield end users from schema complexity.
   - Aggregations in views can be used as data sources for BI dashboards.
===========================================================
*/

-- 1. Transaction-level enriched view
CREATE OR REPLACE VIEW vw_sales_detail AS
SELECT o.order_number, f.order_line_num, f.quantity, f.cost, f.price, f.sales, f.profit,
d.year_id, p.product_line, p.msrp, c.company_name, c.customer_firstname,c.customer_lastname,
g.city, g.state, g.country, g.territory, o.deal_size, f.status
FROM fact_sales AS f
JOIN dim_date AS d
	ON f.order_date = d.order_date
JOIN dim_product AS p
	ON f.product_code = p.product_code
JOIN dim_customer AS c
	ON f.customer_id = c.customer_id
JOIN dim_geography AS g
	ON c.geo_id = g.geo_id
JOIN dim_order AS o
	ON f.order_number = o.order_number;

-- 2. Sales and Profit aggregated by year
CREATE OR REPLACE VIEW vw_sales_year AS
SELECT d.year_id, SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_date AS d
	ON f.order_date = d.order_date
GROUP BY d.year_id
ORDER BY d.year_id DESC;

-- 3.Sales and Profit aggregated by company
CREATE OR REPLACE VIEW vw_sales_company AS
SELECT c.company_name, SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_customer AS c
	ON f.customer_id = c.customer_id
GROUP BY c.company_name
ORDER BY total_sales DESC, total_profit DESC
LIMIT 10;

-- 4. Sales and Profit aggregated by product line
CREATE OR REPLACE VIEW vw_sales_product AS
SELECT p.product_line, SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_product AS p
	ON f.product_code = p.product_code
GROUP BY p.product_line
ORDER BY total_sales DESC, total_profit DESC;

-- 5. Sales and Profit aggregated by country
CREATE OR REPLACE VIEW vw_sales_country AS
SELECT g.country, SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_customer AS c
	ON f.customer_id = c.customer_id
JOIN dim_geography AS g
	ON c.geo_id = g.geo_id
GROUP BY g.country
ORDER BY total_sales DESC, total_profit DESC;

-- 6. Sales and Profit aggregated by territory
CREATE OR REPLACE VIEW vw_sales_territory AS
SELECT g.territory, SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_customer AS c
	ON f.customer_id = c.customer_id
JOIN dim_geography AS g
	ON c.geo_id = g.geo_id
GROUP BY g.territory
ORDER BY total_sales DESC, total_profit DESC;

-- 7. Sales and Profit aggregated by deal size
CREATE OR REPLACE VIEW vw_sales_deal_size AS
SELECT o.deal_size, SUM(f.sales) AS total_sales, SUM(f.profit) AS total_profit
FROM fact_sales AS f
JOIN dim_order AS o
	ON f.order_number = o.order_number
GROUP BY o.deal_size
ORDER BY total_sales DESC, total_profit DESC;