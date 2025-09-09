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
   - date_id → dim_date
   - geo_id → dim_geography
   - customer_id → dim_customer
   - product_id → dim_product
   - size_id → dim_deal_size
   - status_id → dim_status
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
product_id, customer_id, date_id, size_id, status_id)
SELECT s.order_number, s.order_line_num, s.quantity, ROUND(s.price * 0.7, 2) AS cost, s.price,
s.sales, ROUND(s.sales - (ROUND(s.price * 0.7, 2) * quantity), 2) AS profit, p.product_id,
c.customer_id, d.date_id, ds.size_id, st.status_id
FROM staging_sales AS s
LEFT JOIN dim_product AS p
	ON s.product_code = p.product_code
LEFT JOIN dim_customer AS c
	ON s.company_name = c.company_name
	AND s.customer_firstname = c.customer_firstname
	AND s.customer_lastname = c.customer_lastname
LEFT JOIN dim_date AS d
	ON s.order_date = d.order_date
LEFT JOIN dim_deal_size AS ds
	ON s.deal_size = ds.deal_size
LEFT JOIN dim_status AS st
	ON s.status = st.status
ORDER BY s.order_number;