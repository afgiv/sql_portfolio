/*
===========================================================
 Model:       stg_orders.sql
 Purpose:     Clean and standardize raw order data.
 Author:      Amadeo F. Genio IV
 Description: 
   - Removes exact duplicates.
   - Standardizes order status text.
   - Renames and clarifies timestamp columns for analysis.
   - Prepares shipping and delivery fields for SLA checks.
 Notes:
   - Run after `raw.orders` has been loaded.
   - Can be used to compare expected vs actual shipping and delivery.
============================================================
*/

WITH deduplicate AS (
    SELECT DISTINCT *
    FROM {{ source('raw', 'orders')}}
), standardize AS (
    SELECT order_id, customer_id, INITCAP(order_status) AS status,
    order_purchase_timestamp AS date_purchased,
    order_approved_at AS date_processed,
    order_delivered_carrier_date AS date_shipped,
    order_estimated_delivery_date AS expected_delivery_date,
    order_delivered_customer_date AS date_delivered
    FROM deduplicate
), final AS (
    SELECT *
    FROM standardize
)

SELECT * FROM final;