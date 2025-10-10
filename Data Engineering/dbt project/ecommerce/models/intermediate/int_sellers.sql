WITH sellers AS (
    SELECT *
    FROM {{ ref('stg_sellers') }}
), geolocation AS (
    SELECT s.seller_id,
    COALESCE(g.zip_code_prefix, s.zip_code_prefix) AS zip_code_prefix,
    g.latitude AS seller_lat, g.longitude AS seller_lng,
    COALESCE(g.city, s.city) AS seller_city, g.state AS seller_state
    FROM sellers AS s
    LEFT JOIN {{ ref('stg_geolocation') }} AS g
        ON s.zip_code_prefix = g.zip_code_prefix
), final AS (
    SELECT *
    FROM geolocation
)

SELECT * FROM final