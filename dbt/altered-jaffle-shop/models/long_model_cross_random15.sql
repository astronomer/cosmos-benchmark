{{ config(
    materialized = "table"
) }}

WITH params AS (
  SELECT array_x, array_y
  FROM {{ ref('model_params') }}
  WHERE model_name = 'long_model_cross_random'
  LIMIT 1
),
base AS (
  SELECT * FROM {{ ref('customers') }}
),
inflated AS (
  SELECT
    b.customer_id,
    x AS x_val,
    y AS y_val,
    RAND() * x * y AS random_val
  FROM base b
  CROSS JOIN params p
  CROSS JOIN UNNEST(GENERATE_ARRAY(1, p.array_x)) AS x
  CROSS JOIN UNNEST(GENERATE_ARRAY(1, p.array_y)) AS y
)
SELECT
  customer_id,
  COUNT(*) AS row_count,
  AVG(random_val) AS avg_val
FROM inflated
GROUP BY customer_id
