WITH products AS (
    SELECT *
    FROM {{ ref('stg_products') }}
), product_category AS (
    SELECT p.*, pc.category_translation
    FROM products AS p
    LEFT JOIN {{ ref('stg_product_category') }} AS pc
        On p.category_name = pc.category_name
), final AS (
    SELECT *
    FROM product_category
)

SELECT * FROM final