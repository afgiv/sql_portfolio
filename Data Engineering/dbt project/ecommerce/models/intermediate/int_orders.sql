WITH order_items AS (
    SELECT *
    FROM {{ ref('stg_order_items') }}
), orders AS (
    SELECT ord.*, o.customer_id, o.status, o.date_purchased, o.date_processed,
    o.date_shipped, o.expected_delivery_date, o.date_delivered
    FROM order_items AS ord
    JOIN {{ ref('stg_orders') }} AS o
        ON ord.order_id = o.order_id
), order_payments AS (
    SELECT o.*, op.attempts_made, op.payment_type, op.payment_installments,
    op.total_payment
    FROM orders AS o
    LEFT JOIN {{ ref('stg_order_payments') }} AS op
        ON o.order_id = op.order_id
), order_reviews AS (
    SELECT op.*, r.review_id, r.score, r.title, r.comment, r.date_submitted, r.date_processed
    AS review_date_processed
    FROM order_payments AS op
    LEFT JOIN {{ ref('stg_order_reviews') }} AS r
        ON op.order_id = r.order_id
), final AS (
    SELECT *
    FROM order_reviews
)

SELECT * FROM final