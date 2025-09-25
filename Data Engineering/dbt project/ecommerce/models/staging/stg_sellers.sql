/*
===========================================================
 Model:       stg_sellers.sql
 Purpose:     Clean and standardize raw seller data.
 Author:      Amadeo F. Genio IV
 Description: 
   - Removes duplicate seller records.
   - Renames columns for clarity (e.g., seller_zip_code_prefix → zip_code_prefix).
   - Standardizes text fields:
       * City names to InitCap format.
       * State abbreviations to uppercase.
 Notes:
   - Run after `raw.sellers` has been loaded.
   - Zip code prefix aligns with customer and geolocation data for joins.
============================================================
*/

{{ config(materialized='incremental', unique_key='seller_id') }}

WITH deduplicate AS (
    SELECT DISTINCT *
    FROM {{ source('raw', 'sellers') }}
), standardize AS (
    SELECT seller_id, seller_zip_code_prefix AS zip_code_prefix,
    INITCAP(seller_city) AS city, UPPER(seller_state) AS state
    FROM deduplicate
), final AS (
    SELECT *
    FROM standardize
)

SELECT * FROM final