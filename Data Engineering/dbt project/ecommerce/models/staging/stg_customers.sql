/*
===========================================================
 Model:       stg_customers.sql
 Purpose:     Clean and standardize raw customer data.
 Author:      Amadeo F. Genio IV
 Description: 
   - Keeps original IDs for order-level and customer-level analysis.
   - Standardizes text fields for consistency.
 Notes:
   - Run after `raw.customers` has been loaded.
============================================================
*/

WITH customers AS (

    SELECT
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        INITCAP(customer_city) AS customer_city,
        UPPER(customer_state) AS customer_state
    FROM raw.customers
)

SELECT * FROM customers;