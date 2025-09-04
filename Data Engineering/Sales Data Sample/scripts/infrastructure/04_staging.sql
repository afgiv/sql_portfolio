/*
===========================================================
 File:        03_staging_load.sql
 Purpose:     Create staging table and load raw CSV data
 Author:      Amadeo F. Genio IV
 Description:
   - Creates the staging table for raw sales data.
   - Loads data from CSV into the staging table.
   - Staging table serves as the source for subsequent
     dimension and fact table loads.
===========================================================
*/

-- 1. Create the table for the staging
CREATE TABLE IF NOT EXISTS staging_sales (
	order_number INTEGER,
	quantity INTEGER,
	price NUMERIC (10, 2),
	order_line_num INTEGER,
	sales NUMERIC (12, 2),
	order_date DATE,
	status VARCHAR (255),
	qtr_id INTEGER,
	month_id INTEGER,
	year_id INTEGER,
	product_line VARCHAR (255),
	msrp INTEGER,
	product_code VARCHAR (255),
	company_name VARCHAR (255),
	phone VARCHAR (20),
	address_1 VARCHAR (255),
	address_2 VARCHAR (255),
	city VARCHAR(255),
	state VARCHAR (255),
	postal_code VARCHAR (255),
	country VARCHAR (255),
	territory VARCHAR (255),
	customer_firstname VARCHAR (255),
	customer_lastname VARCHAR (255),
	deal_size VARCHAR (255)
);