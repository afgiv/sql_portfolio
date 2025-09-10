/*
===========================================================
 File:        create_dims.sql
 Purpose:     Create dimension tables for the Star Schema
 Author:      Amadeo F. Genio IV
 Description: 
   - Defines all dimension tables used in the sales_dw data warehouse.
   - Includes:
       * dim_date
       * dim_geography
       * dim_customer
       * dim_product
	   * dim_deal_size
	   * dim_status
 Notes:
   - Run this script after transformation of the staging table and data profiling
     is set.
   - These tables will store descriptive attributes to support fact table analysis.
   - Primary keys are defined for each dimension table.
   - CONSTRAINT UNIQUE are added to the dims to handle duplications for future
   	 inserts.
===========================================================
*/

-- 1. Date Dimension Table
CREATE TABLE IF NOT EXISTS dim_date (
	date_id SERIAL PRIMARY KEY,
	order_date DATE,
	qtr_id INTEGER NOT NULL,
	month_id INTEGER NOT NULL,
	year_id INTEGER NOT NULL,
	CONSTRAINT dim_date_uq UNIQUE (order_date)
);

-- 2. Geography Dimension Table
CREATE TABLE IF NOT EXISTS dim_geography (
	geo_id SERIAL PRIMARY KEY,
	postal_code VARCHAR(255),
	city VARCHAR (255) NOT NULL,
	state VARCHAR (255) NOT NULL,
	country VARCHAR (255) NOT NULL,
	territory VARCHAR (255) NOT NULL,
	CONSTRAINT dim_geo_uq UNIQUE (postal_code, city, state, country, territory)
);

-- 3. Customer Dimension Table
CREATE TABLE IF NOT EXISTS dim_customer (
	customer_id SERIAL PRIMARY KEY,
	company_name VARCHAR (255) NOT NULL,
	customer_firstname VARCHAR (255) NOT NULL,
	customer_lastname VARCHAR (255) NOT NULL,
	phone VARCHAR(20),
	address_1 VARCHAR (255),
	address_2 VARCHAR (255),
	geo_id INTEGER,
	CONSTRAINT fk_geo FOREIGN KEY (geo_id) REFERENCES dim_geography (geo_id),
	CONSTRAINT dim_cust_uq UNIQUE (company_name, customer_firstname, customer_lastname)
);

-- 4. Products Dimension Table
CREATE TABLE IF NOT EXISTS dim_product (
	product_id SERIAL PRIMARY KEY,
	product_code VARCHAR(255) NOT NULL,
	product_line VARCHAR (255) NOT NULL,
	msrp INTEGER NOT NULL,
	CONSTRAINT dim_prod_uq UNIQUE (product_code)
);

-- 5. Deal size Dimension Table
CREATE TABLE IF NOT EXISTS dim_deal_size(
	size_id SERIAL PRIMARY KEY,
	deal_size VARCHAR (255) NOT NULL,
	CONSTRAINT dim_deal_uq UNIQUE (deal_size)
);

-- 6. Status Dimension Table
CREATE TABLE IF NOT EXISTS dim_status (
	status_id SERIAL PRIMARY KEY,
	status VARCHAR (255) NOT NULL,
	CONSTRAINT dim_status_uq UNIQUE (status)
);