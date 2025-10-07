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
), max_review AS (
    SELECT order_id, MAX(review_creation_date) AS review_creation_date,
    AVG(review_score) AS review_score,
    MAX(review_answer_timestamp) AS review_answer_timestamp
    FROM deduplicate
    GROUP BY order_id
), full_table AS (
    SELECT d.review_id, m.order_id, m.review_score, d.review_comment_title,
    d.review_comment_message, m.review_creation_date, m.review_answer_timestamp
    FROM deduplicate AS d
    JOIN max_review AS m
        ON d.order_id = m.order_id
        AND d.review_creation_date = m.review_creation_date
        AND d.review_answer_timestamp = m.review_answer_timestamp
),standardize AS (
    SELECT review_id, order_id, review_score AS score,
    INITCAP(review_comment_title) AS title, review_comment_message AS comment,
    review_creation_date AS date_submitted,
    review_answer_timestamp AS date_processed
    FROM full_table
), final AS (
    SELECT *
    FROM standardize
)

SELECT * FROM final