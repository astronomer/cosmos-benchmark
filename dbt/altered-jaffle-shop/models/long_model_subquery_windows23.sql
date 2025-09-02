{{ config(
    materialized = "table"
) }}

WITH params AS (
  SELECT array_x
  FROM {{ ref('model_params') }}
  WHERE model_name = 'long_model_subquery_windows'
  LIMIT 1
),

-- Inflate base rows by duplicating each customer 100x
base AS (
  SELECT
    c.customer_id,
    d AS duplication_id
  FROM {{ ref('customers') }} c
  CROSS JOIN UNNEST(GENERATE_ARRAY(1, 100)) AS d
),

-- Generate large expansion using params
expanded AS (
  SELECT
    b.customer_id,
    x AS factor,
    POW(x, 0.5) AS sqrt_x,
    SAFE_DIVIDE(x, NULLIF(MOD(x, 10), 0)) AS ratio,
    LOG(x + 1) + SIN(x) + COS(x) AS expensive_math
  FROM base b
  CROSS JOIN params p
  CROSS JOIN UNNEST(GENERATE_ARRAY(1, p.array_x)) AS x
),

-- Complex windowing across a large range
windowed AS (
  SELECT
    *,
    AVG(expensive_math) OVER (
      PARTITION BY customer_id
      ORDER BY factor
      ROWS BETWEEN 10000 PRECEDING AND CURRENT ROW
    ) AS moving_avg
  FROM expanded
),

aggregated AS (
  SELECT
    customer_id,
    SUM(moving_avg) AS total_avg,
    COUNT(*) AS cnt
  FROM windowed
  GROUP BY customer_id
)

SELECT * FROM aggregated
