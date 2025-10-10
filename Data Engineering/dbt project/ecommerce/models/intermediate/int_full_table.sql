WITH orders AS (
    SELECT *
    FROM {{ ref('int_orders') }}
), products AS (
    SELECT o.*, p.category_name, p.category_translation, p.title_length,
    p.description_length, p.photos_qty, p.weight_g, p.length_cm, p.height_cm,
    p.width_cm
    FROM orders AS o
    LEFT JOIN {{ ref('int_products') }} AS p
        ON o.product_id = p.product_id
), customers AS (
    SELECT p.*, c.customer_unique_id, c.zip_code_prefix AS customer_zip_code,
    c.customer_lat, c.customer_lng, c.customer_city, c.customer_state
    FROM products AS p
    LEFT JOIN {{ ref('int_customers') }} AS c
        ON p.customer_id = c.customer_id
), sellers AS (
    SELECT c.*, s.zip_code_prefix AS seller_zip_code, s.seller_lat, s.seller_lng,
    s.seller_city, s.seller_state
    FROM customers AS c
    LEFT JOIN {{ ref('int_sellers') }} AS  s
        ON c.seller_id = s.seller_id
), final AS (
    SELECT *
    FROM sellers
)

SELECT * FROM final