WITH products AS (
    SELECT *
    FROM {{ ref('stg_products') }}
), product_category AS (
    SELECT p.product_id, pc.category_name, pc.category_translation, p.title_length,
    p.description_length, p.photos_qty, p.weight_g, p.length_cm, p.height_cm, p.width_cm
    FROM products AS p
    LEFT JOIN {{ ref('stg_product_category') }} AS pc
        On p.category_name = pc.category_name
), final AS (
    SELECT *
    FROM product_category
)

SELECT * FROM final