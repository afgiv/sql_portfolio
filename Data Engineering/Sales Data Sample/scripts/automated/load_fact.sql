/*
===========================================================
 File:        load_fact.sql
 Purpose:     Define and create the fact_sales table
 Author:      Amadeo F. Genio IV
 Description:
   - Central fact table in the star schema.
   - Stores transaction-level sales data with measures 
     and foreign keys to dimension tables.
   - Surrogate keys from dimension tables ensure referential
     integrity and enable flexible analysis.
   - Designed to support queries on revenue, quantity,
     and other metrics across multiple business dimensions.
 Fact Table:
   - fact_sales
 Measures:
   - sales (numeric measure of gross revenue)
   - quantity (units sold)
   - cost (derived measure, estimated using an assumed 
     price markup % due to missing cost data)
   - profit (sales - cost, based on the derived cost measure)
 Foreign Keys:
   - order_date → dim_date
   - geo_id → dim_geography
   - customer_id → dim_customer
   - product_code → dim_product
   - order_number → dim_order
 Notes:
   - Uses surrogate keys, not natural keys, for joins.
   - Designed for repeatable, idempotent ETL loads.
   - Cost/Profit assumptions:
       * Since cost is not provided in the dataset, an 
         estimated cost is derived by applying an assumed 
         price markup of 70%.
       * Profit is therefore an estimated measure, not an 
         exact business metric.
   - Populated only after all dimension tables are loaded.
===========================================================
*/

INSERT INTO fact_sales (order_number, order_line_num, quantity, cost, price, sales, profit,
product_code, customer_id, order_date, status)
SELECT o.order_number, s.order_line_num, s.quantity, ROUND(s.price * 0.7, 2) AS cost, s.price,
s.sales, ROUND(s.sales - (ROUND(s.price * 0.7, 2) * quantity), 2) AS profit, p.product_code,
c.customer_id, d.order_date, s.status
FROM staging_sales AS s
JOIN dim_order AS o
	ON s.order_number = o.order_number
JOIN dim_product AS p
	ON s.product_code = p.product_code
LEFT JOIN dim_customer AS c
	ON s.company_name = c.company_name
	AND s.customer_firstname = c.customer_firstname
	AND s.customer_lastname = c.customer_lastname
JOIN dim_date AS d
	ON s.order_date = d.order_date
ORDER BY o.order_number;