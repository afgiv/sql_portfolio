/*
===========================================================
 Model:       stg_geolocation.sql
 Purpose:     Clean and standardize raw geolocation data.
 Author:      Amadeo F. Genio IV
 Description: 
   - Removes exact duplicates.
   - Aggregates multiple records per zip code prefix to a single reference.
   - Uses AVG for latitude/longitude to get a representative point.
   - Uses MIN for city/state to enforce consistency.
   - Standardizes text fields for consistency.
 Notes:
   - Run after `raw.geolocation` has been loaded.
   - Be aware that zip prefixes are approximate and may cover multiple areas.
============================================================
*/

WITH deduplicate AS (
  SELECT DISTINCT *
  FROM {{ source('raw', 'geolocation') }}
), standardize AS (
  SELECT geolocation_zip_code_prefix AS zip_code_prefix,
  geolocation_lat AS latitude,
  geolocation_lng AS longitude,
  INITCAP(geolocation_city) AS city,
  UPPER(geolocation_state) AS state
  FROM deduplicate
), condense AS (
  SELECT zip_code_prefix,
  AVG(latitude),
  AVG(longitude,)
  MIN(city),
  MIN(state) AS state
  FROM standardize
  GROUP BY zip_code_prefix
), final AS (
  SELECT *
  FROM condense
)

SELECT * FROM final;