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
	product_code VARCHAR (255) NOT NULL,
	customer_id INTEGER NOT NULL,
	order_date DATE NOT NULL,
	status VARCHAR (255) NOT NULL,
	CONSTRAINT fact_pk PRIMARY KEY (order_number, order_line_num),
	CONSTRAINT fk_order FOREIGN KEY (order_number) REFERENCES dim_order (order_number),
	CONSTRAINT fk_prod FOREIGN KEY (product_code) REFERENCES dim_product (product_code),
	CONSTRAINT fk_cust FOREIGN KEY (customer_id) REFERENCES dim_customer (customer_id),
	CONSTRAINT fk_date FOREIGN KEY (order_date) REFERENCES dim_date (order_date)
);