WITH sellers AS (
    SELECT *
    FROM {{ ref('stg_sellers') }}
), geolocation AS (
    SELECT s.*, g.latitude AS seller_lat, g.longitude AS seller_lng,
    g.city AS seller_city, g.state AS seller_state
    FROM sellers AS s
    JOIN {{ ref('stg_geolocation') }} AS g
        ON s.zip_code_prefix = g.zip_code_prefix
), final AS (
    SELECT *
    FROM geolocation
)

SELECT * FROM final