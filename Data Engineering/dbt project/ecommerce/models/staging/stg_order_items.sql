/*
===========================================================
 Model:       stg_order_items.sql
 Purpose:     Clean and standardize raw order items data.
 Author:      Amadeo F. Genio IV
 Description: 
   - Removes exact duplicates from `raw.order_items`.
   - Filters out rows with non-positive price or shipping values.
   - Renames columns for clarity:
       - `order_item_id` → `order_item_num`
       - `shipping_limit_date` → `expected_shipping_date`
       - `freight_value` → `shipping_cost`
 Notes:
   - Run after `raw.order_items` has been loaded.
   - Ensure that `price` and `freight_value` are positive for valid transactions.
============================================================
*/

WITH deduplicate AS (
    SELECT DISTINCT *
    FROM {{ source('raw', 'order_items') }}
), standardize AS (
    SELECT order_id, order_item_id AS order_item_num, product_id,
    seller_id, shipping_limit_date AS expected_shipping_date,
    price, freight_value AS shipping_cost
    FROM deduplicate
), integrity AS (
    SELECT *
    FROM standardize
    WHERE price > 0 AND shipping_cost > 0
), final AS (
    SELECT *
    FROM integrity
)

SELECT * FROM final;