{{ config(
    materialized = "table"
) }}

WITH params AS (
  SELECT array_x, array_y
  FROM {{ ref('model_params') }}
  WHERE model_name = 'customers_slow_query'
  LIMIT 1
),
base AS (
  SELECT * FROM {{ ref('customers') }}
),
expanded AS (
  SELECT
    b.*,
    x AS extra_x,
    y AS extra_y
  FROM base b
  CROSS JOIN params p
  CROSS JOIN UNNEST(GENERATE_ARRAY(1, p.array_x)) AS x
  CROSS JOIN UNNEST(GENERATE_ARRAY(1, p.array_y)) AS y
),
windowed AS (
  SELECT
    *,
    AVG(LENGTH(CAST(customer_id AS STRING))) OVER (
      PARTITION BY customer_id
      ORDER BY extra_x, extra_y
    ) AS avg_len
  FROM expanded
)
SELECT
  customer_id,
  SUM(avg_len) AS sum_len
FROM windowed
GROUP BY customer_id
