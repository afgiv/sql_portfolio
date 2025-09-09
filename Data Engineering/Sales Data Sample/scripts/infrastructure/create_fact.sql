/*
===========================================================
 File:        create_fact.sql
 Purpose:     Create the fact table for the sales_db schema
 Author:      Amadeo F. Genio IV
 Description: 
   - Defines the central fact table storing measurable 
     business events for analysis.
   - Granularity: One row per order line.
   - Includes foreign keys to dimension tables and 
     numerical measures for analysis.
===========================================================
*/

CREATE TABLE IF NOT EXISTS fact_sales (
	order_number INTEGER,
	order_line_num INTEGER,
	quantity INTEGER NOT NULL,
	cost NUMERIC (10, 2) NOT NULL,
	price NUMERIC(10, 2) NOT NULL,
	sales NUMERIC(12, 2) NOT NULL,
	profit NUMERIC (12, 2) NOT NULL,
	product_id INTEGER NOT NULL,
	customer_id INTEGER NOT NULL,
	date_id INTEGER NOT NULL,
	size_id INTEGER NOT NULL,
	status_id INTEGER NOT NULL,
	CONSTRAINT fact_pk PRIMARY KEY (order_number, order_line_num),
	CONSTRAINT fk_prod FOREIGN KEY (product_id) REFERENCES dim_product (product_id),
	CONSTRAINT fk_cust FOREIGN KEY (customer_id) REFERENCES dim_customer (customer_id),
	CONSTRAINT fk_date FOREIGN KEY (date_id) REFERENCES dim_date (date_id),
	CONSTRAINT fk_size FOREIGN KEY (size_id) REFERENCES dim_deal_size (size_id),
	CONSTRAINT fk_status FOREIGN KEY (status_id) REFERENCES dim_status (status_id)
);