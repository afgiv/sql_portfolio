WITH order_items AS (
    SELECT *
    FROM {{ ref('stg_order_items') }}
), orders AS (
    SELECT or.*, o.date_purchased, o.date_processed, o.date_shipped,
    o.expected_delivery_date, o.date_delivered
    FROM order_items AS or
    JOIN {{ ref('stg_orders') }} AS o
        ON or.order_id = o.order_id
), products AS (
    SELECT o.*, p.category_name, p.title_length, p.description_length,
    p.photos_qty, p.weight_g, p.length_cm, p.height_cm, p.width_cm
    FROM orders AS o
    JOIN {{ ref('stg_products') }} AS p
        ON o.product_id = p.product_id
), product_category AS (
    SELECT p.*, pc.category_translation
    FROM products AS p
    JOIN {{ ref('stg_product_category') }} AS pc
        ON p.category_name = pc.category_name
), sellers AS (
    SELECT pc.*, s.zip_code_prefix, s.city AS seller_city, s.state
    AS seller_state
    FROM product_category AS pc
    JOIN {{ ref('stg_sellers') }} AS s
        ON pc.seller_id = s.seller_id
), geolocation AS (
    SELECT s.*, g.latitude, g.longitude, g.city, g.state
    FROM sellers AS s
    JOIN {{ ref('stg_geolocation') }} AS g
        ON s.zip_code_prefix = g.zip_code_prefix
), customers AS (
    SELECT g.*, c.customer_unique_id, c.city AS customer_city,
    c.state AS customer_state
    FROM geolocation AS g
    JOIN {{ ref('stg_customers') }} AS c
        ON g.customer_id = c.customer_id
), order_payments AS (
    SELECT c.*, op.attemps_made, op.payment_type, op.payment_installments,
    op.total_payment
    FROM customers AS c
    JOIN {{ ref('stg_order_payments') }} AS op
        ON c.order_id = op.order_id
), order_reviews AS (
    SELECT op.*, r.review_id, r.score, r.title, r.comment, r.date_submitted,
    r.date_processed
    FROM order_payments AS op
    JOIN {{ ref('stg_order_reviews') }} AS r
        ON op.order_id = r.order_id
), final AS (
    SELECT *
    FROM order_reviews
)

SELECT * FROM final