/*
===========================================================
 Model:       stg_product_category.sql
 Purpose:     Clean and standardize raw product category data.
 Author:      Amadeo F. Genio IV
 Description: 
   - Removes exact duplicates.
   - Replaces underscores in category names for readability.
   - Standardizes both original and English translations using proper casing.
   - Provides clear and human-friendly category names for analysis.
 Notes:
   - Run after `raw.product_category` has been loaded.
   - Useful for joining product tables with descriptive categories.
============================================================
*/

{{ config(unique_key=['category_name', 'category_translation']) }}

WITH deduplicate AS (
    SELECT DISTINCT *
    FROM {{ source('raw', 'product_category')}}
), replace AS (
    SELECT REPLACE(product_category_name, '_', ' ') AS product_category_name,
    REPLACE(product_category_name_english, '_', ' ') AS product_category_name_english
    FROM deduplicate
), standardize AS (
    SELECT INITCAP(product_category_name) AS category_name,
    INITCAP(product_category_name_english) AS category_translation
    FROM replace
), final AS (
    SELECT *
    FROM standardize
)

SELECT * FROM final