{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01566') }},
        {{ ref('model_01531') }}
)
select id, 'model_02327' as name from sources
