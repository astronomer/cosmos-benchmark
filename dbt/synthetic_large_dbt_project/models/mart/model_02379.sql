{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01850') }},
        {{ ref('model_01782') }},
        {{ ref('model_02050') }}
)
select id, 'model_02379' as name from sources
