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

{{ config(unique_key=['order_id', 'order_item_num']) }}

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
), consistency AS (
    SELECT *
    FROM integrity
    WHERE order_id IN (
        SELECT order_id
        FROM {{ ref('stg_orders') }}
    )
), consistency_2 AS (
    SELECT *
    FROM consistency
    WHERE product_id IN (
        SELECT product_id
        FROM {{ ref('stg_products')}}
    )
), final AS (
    SELECT *
    FROM consistency_2
)

SELECT * FROM final