/*
===========================================================
 Model:       stg_order_reviews.sql
 Purpose:     Clean and standardize raw order review data.
 Author:      Amadeo F. Genio IV
 Description: 
   - Removes duplicate records from the raw dataset.
   - Renames columns for clarity (e.g., review_score → score).
   - Captures both timestamps:
       * date_submitted = when the customer created the review.
       * date_processed = when the platform system recorded it.
 Notes:
   - Use `date_processed` as the reliable review timestamp for analysis.
   - Keep `date_submitted` for latency checks between submission 
     and system processing.
============================================================
*/

{{ config(unique_key=['review_id', 'order_id']) }}

WITH deduplicate AS (
    SELECT DISTINCT *
    FROM {{ source('raw', 'order_reviews') }}
),standardize AS (
    SELECT review_id, order_id, review_score AS score,
    INITCAP(review_comment_title) AS title, review_comment_message AS comment,
    review_creation_date AS date_submitted,
    review_answer_timestamp AS date_processed
    FROM deduplicate
), final AS (
    SELECT *
    FROM standardize
)

SELECT * FROM final