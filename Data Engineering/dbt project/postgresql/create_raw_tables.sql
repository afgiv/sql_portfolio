/*
===========================================================
 File:        create_raw_tables.sql
 Purpose:     Create raw tables to store untouched source data.
 Author:      Amadeo F. Genio IV
 Description: 
   - Defines tables in the raw schema to hold data loaded
     directly from source files (CSV, API, etc.).
   - No transformations are applied here; the tables are
     intended to preserve the original data.
 Notes:
   - Must be run after the raw schema has been created.
   - Tables should align with the columns and types in the source files.
   - These tables will be used later by dbt for staging and transformations.
============================================================
*/

-- 1. Create the table for the 'olist_customers_dataset'
CREATE TABLE IF NOT EXISTS raw.customers (
	customer_id VARCHAR(100),
	customer_unique_id VARCHAR(100),
	customer_zip_code_prefix INTEGER,
	customer_city VARCHAR(50),
	customer_state CHAR(2)
);

-- 2. Create the table for the 'olist_geolocation_dataset'
CREATE TABLE IF NOT EXISTS raw.geolocation (
	geolocation_zip_code_prefix INTEGER,
	geolocation_lat DOUBLE PRECISION,
	geolocation_lng DOUBLE PRECISION,
	geolocation_city VARCHAR(50),
	geolocation_state CHAR(2)
);

-- 3. Create the table for the 'olist_order_items_dataset'
CREATE TABLE IF NOT EXISTS raw.order_items (
	order_id VARCHAR(100),
	order_item_id INTEGER,
	product_id VARCHAR(100),
	seller_id VARCHAR(100),
	shipping_limit_date TIMESTAMP,
	price NUMERIC(10, 2),
	freight_value NUMERIC(10, 2)
);

-- 4. Create the table for the 'olist_order_payments_dataset'
CREATE TABLE IF NOT EXISTS raw.order_payments (
	order_id VARCHAR(100),
	payment_sequential INTEGER,
	payment_type VARCHAR(50),
	payment_installments INTEGER,
	payment_value NUMERIC(10, 2)
);

-- 5. Create the table for the 'olist_order_reviews_dataset'
CREATE TABLE IF NOT EXISTS raw.order_reviews (
	review_id VARCHAR(100),
	order_id VARCHAR(100),
	review_score INTEGER,
	review_comment_title TEXT,
	review_comment_message TEXT,
	review_creation_date TIMESTAMP,
	review_answer_timestamp TIMESTAMP
);

-- 6. Create the table for the 'olist_orders_dataset'
CREATE TABLE IF NOT EXISTS raw.orders (
	order_id VARCHAR(100),
	customer_id VARCHAR(100),
	order_status VARCHAR(50),
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP
);

-- 7. Create the table for the 'olist_products_dataset'
CREATE TABLE IF NOT EXISTS raw.products (
	product_id VARCHAR(100),
	product_category_name VARCHAR(50),
	product_name_length NUMERIC(10, 1),
	product_description_length NUMERIC(10, 1),
	product_photos_qty NUMERIC(10, 1),
	product_weight_g NUMERIC(10, 1),
	product_length_cm NUMERIC(10, 1),
	product_height_cm NUMERIC(10, 1),
	product_width_cm NUMERIC(10, 1)
);

-- 8. Create the table for the 'olist_sellers_dataset'
CREATE TABLE IF NOT EXISTS raw.sellers (
	seller_id VARCHAR(100),
	seller_zip_code_prefix INTEGER,
	seller_city VARCHAR(50),
	seller_state CHAR(2)
);

-- 9. Create the table for the 'product_category_name_translation'
CREATE TABLE IF NOT EXISTS raw.product_category (
	product_category_name VARCHAR(50),
	product_category_name_english VARCHAR(50)
);