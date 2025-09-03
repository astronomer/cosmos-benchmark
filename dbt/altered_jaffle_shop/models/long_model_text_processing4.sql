{{ config(
    materialized = "table"
) }}

WITH params AS (
  SELECT array_x, array_y
  FROM {{ ref('model_params') }}
  WHERE model_name = 'long_model_text_processing'
  LIMIT 1
),
base AS (
  SELECT * FROM {{ ref('customers') }}
),
text_gen AS (
  SELECT
    b.customer_id,
    CONCAT('Customer_', CAST(x AS STRING), '_', CAST(y AS STRING)) AS tag,
    REPEAT('A', MOD(x * y, 1000)) AS description
  FROM base b
  CROSS JOIN params p
  CROSS JOIN UNNEST(GENERATE_ARRAY(1, p.array_x)) AS x
  CROSS JOIN UNNEST(GENERATE_ARRAY(1, p.array_y)) AS y
),
analyzed AS (
  SELECT
    customer_id,
    LENGTH(tag) AS tag_len,
    LENGTH(description) AS desc_len,
    RANK() OVER (PARTITION BY customer_id ORDER BY LENGTH(description) DESC) AS rank_val
  FROM text_gen
),
filtered AS (
  SELECT * FROM analyzed
  WHERE rank_val <= 100
)
SELECT
  customer_id,
  AVG(tag_len) AS avg_tag_len,
  MAX(desc_len) AS max_desc_len
FROM filtered
GROUP BY customer_id
