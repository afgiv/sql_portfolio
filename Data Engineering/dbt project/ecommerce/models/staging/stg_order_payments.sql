/*
===========================================================
 Model:       stg_order_payments.sql
 Purpose:     Clean and standardize raw order payments data.
 Author:      Amadeo F. Genio IV
 Description: 
   - Removes duplicate records from the raw dataset.
   - Standardizes payment_type text for readability.
   - Aggregates multiple payment attempts per order:
       • Keeps the maximum payment attempt number.
       • Sums payment values to capture the full amount paid.
       • Retains the final payment_type and installment details.
 Notes:
   - Run after `raw.order_payments` has been loaded.
   - Some orders have multiple retries (payment_attempts > 1), 
     but the total_payment reflects the true amount collected.
============================================================
*/

{{ config(unique_key='order_id') }}

WITH deduplicate AS (
    SELECT DISTINCT *
    FROM {{ source('raw', 'order_payments') }}
), replace AS (
    SELECT order_id, payment_sequential,
    REPLACE(payment_type, '_', ' ') AS payment_type,
    payment_installments, payment_value
    FROM deduplicate
), standardize AS (
    SELECT order_id, payment_sequential AS payment_attempts,
    INITCAP(payment_type) AS payment_type, payment_installments, payment_value
    FROM replace
), max_attempts AS (
    SELECT order_id, MAX(payment_attempts) as attempts_made,
    SUM(payment_value) AS total_payment
    FROM standardize
    GROUP BY order_id
), full_table AS (
    SELECT s.order_id, m.attempts_made, s.payment_type,
    s.payment_installments, m.total_payment
    FROM standardize AS s
    JOIN max_attempts AS m
        ON s.order_id = m.order_id
        AND s.payment_attempts = m.attempts_made
), final AS (
    SELECT *
    FROM full_table
)

SELECT * FROM final