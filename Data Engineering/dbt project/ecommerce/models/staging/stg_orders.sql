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

{{ config(unique_key='order_id') }}

WITH deduplicate AS (
    SELECT DISTINCT *
    FROM {{ source('raw', 'orders')}}
), misspelled AS (
  SELECT order_id, customer_id, CASE WHEN order_status = 'canceled' THEN 'cancelled'
  ELSE order_status END AS order_status, order_purchase_timestamp, order_approved_at,
  order_delivered_carrier_date, order_estimated_delivery_date, order_delivered_customer_date
  FROM deduplicate
), anomaly_1 AS (
  SELECT *
  FROM misspelled
  WHERE order_id NOT IN (
      SELECT order_id
      FROM misspelled
      WHERE order_approved_at IS NULL AND order_status = 'delivered'
  )
), anomaly_2 AS (
  SELECT *
  FROM anomaly_1
  WHERE order_id NOT IN (
    SELECT order_id
    FROM anomaly_1
    WHERE order_delivered_carrier_date IS NULL
    AND order_status = 'delivered'
  )
), standardize AS (
    SELECT order_id, customer_id, INITCAP(order_status) AS status,
    order_purchase_timestamp AS date_purchased,
    order_approved_at AS date_processed,
    order_delivered_carrier_date AS date_shipped,
    order_estimated_delivery_date AS expected_delivery_date,
    order_delivered_customer_date AS date_delivered
    FROM anomaly_2
), final AS (
    SELECT *
    FROM standardize
)

SELECT * FROM final
{% if is_incremental() %}
WHERE date_purchased > (SELECT MAX(date_purchased) FROM {{ this }})
{% endif %}