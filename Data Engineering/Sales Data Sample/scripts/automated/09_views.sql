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
   - vw_sales_detail       (transaction-level enriched view)
   - vw_sales_by_year      (aggregated by year)
   - vw_sales_by_customer  (aggregated by customer/company)
   - vw_sales_by_product   (aggregated by product)
 Notes:
   - Views are read-only and should not be updated directly.
   - Designed to shield end users from schema complexity.
   - Aggregations in views can be used as data sources for BI dashboards.
===========================================================
*/

-- 1. Transaction-level enriched view
CREATE OR REPLACE VIEW vw_sales_detail AS
SELECT o.order_number, f.order_line_num, f.quantity, f.cost, f.price, f.sales, f.profit,
d.order_date, d.year_id, p.product_line, p.msrp, c.company_name, c.customer_firstname,
c.customer_lastname, g.city, g.state, g.country, g.territory, o.deal_size, f.status
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

-- 2. 
