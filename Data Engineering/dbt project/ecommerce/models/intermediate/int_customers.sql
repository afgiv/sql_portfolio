WITH customers AS (
    SELECT *
    FROM {{ ref('stg_customers') }}
), geolocation AS (
    SELECT c.customer_id, c.customer_unique_id,
    COALESCE(g.zip_code_prefix, c.zip_code_prefix) AS zip_code_prefix,
    g.latitude AS customer_lat, g.longitude AS customer_lng,
    COALESCE(g.city, c.city) AS customer_city, g.state AS customer_state
    FROM customers AS c
    LEFT JOIN {{ ref('stg_geolocation') }} AS g
        ON c.zip_code_prefix = g.zip_code_prefix
), final AS (
    SELECT *
    FROM geolocation
)

SELECT * FROM final