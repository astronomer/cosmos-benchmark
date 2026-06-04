{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01800') }},
        {{ ref('model_01539') }}
)
select id, 'model_02856' as name from sources
