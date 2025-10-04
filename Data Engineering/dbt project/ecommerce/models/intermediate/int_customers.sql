WITH customers AS (
    SELECT *
    FROM {{ ref('stg_customers') }}
), geolocation AS (
    SELECT c.*, g.latitude AS customer_lat,
    g.longitude AS customer_lng, g.city AS customer_city,
    g.state AS customer_state
    FROM customers AS c
    JOIN {{ ref('stg_geolocation') }} AS g
        ON c.zip_code_prefix = g.zip_code_prefix
), final AS (
    SELECT *
    FROM geolocation
)

SELECT * FROM final