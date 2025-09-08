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
	   * dim_order
 Notes:
   - Run this script after initializing the database.
   - These tables will store descriptive attributes to support fact table analysis.
   - Primary keys are defined for each dimension table.
   - CONSTRAINT UNIQUE are added to both dim_customer and dim_geography to handle duplication
     for future inserts.
===========================================================
*/

-- 1. Date Dimension Table
CREATE TABLE IF NOT EXISTS dim_date (
	order_date DATE PRIMARY KEY,
	qtr_id INTEGER NOT NULL,
	month_id INTEGER NOT NULL,
	year_id INTEGER NOT NULL
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
	product_code VARCHAR(255) PRIMARY KEY,
	product_line VARCHAR (255) NOT NULL,
	msrp INTEGER NOT NULL
);

-- 5.Orders Dimension Table
CREATE TABLE IF NOT EXISTS dim_order (
	order_number INTEGER PRIMARY KEY,
	deal_size VARCHAR (255) NOT NULL
);