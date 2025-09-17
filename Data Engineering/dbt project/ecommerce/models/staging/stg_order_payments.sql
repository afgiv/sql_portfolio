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
    INITCAP(payment_type), payment_installments, payment_value
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