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

{{ config(materialized='incremental', unique_key='customer_id') }}

WITH deduplicate AS (
  SELECT DISTINCT *
  FROM {{ source('raw', 'customers') }}
), standardize AS (
    SELECT
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix AS zip_code_prefix,
        INITCAP(customer_city) AS city, 
        UPPER(customer_state) AS state
    FROM deduplicate
), final AS (
  SELECT *
  FROM standardize
)

SELECT * FROM final;