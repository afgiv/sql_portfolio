/*
===========================================================
 Model:       stg_products.sql
 Purpose:     Clean and standardize raw product data.
 Author:      Amadeo F. Genio IV
 Description: 
   - Removes duplicate product records.
   - Replaces underscores in category names with spaces.
   - Drops values with data inconsistency (values with 0).
   - Standardizes column names for clarity (e.g., title_length, 
     description_length, photos_qty, weight_g, length_cm, height_cm, width_cm).
   - Applies INITCAP to product category names for readability.
 Notes:
   - Run after `raw.products` has been loaded.
   - Some products may still have missing or incomplete measurements.
============================================================
*/

WITH deduplicate AS (
    SELECT DISTINCT *
    FROM {{ source('raw', 'products')}}
), zeroes AS (
    SELECT product_id, product_category_name, product_name_length,
    product_description_length, product_photos_qty, product_weight_g,
    product_length_cm, product_height_cm, product_width_cm
    FROM deduplicate
    WHERE product_weight_g > 0
), replace AS (
    SELECT product_id, REPLACE(product_category_name, '_', ' ') AS product_category_name,
    product_name_length, product_description_length, product_photos_qty,
    product_weight_g, product_length_cm, product_height_cm, product_width_cm
    FROM zeroes
), standardize AS (
    SELECT product_id, INITCAP(product_category_name) AS category_name,
    product_name_length AS title_length, product_description_length AS description_length,
    product_photos_qty AS photos_qty, product_weight_g AS weight_cm,
    product_length_cm AS length_cm, product_width_cm AS width_cm
    FROM replace
), final AS (
    SELECT *
    FROM standardize
)

SELECT * FROM final;