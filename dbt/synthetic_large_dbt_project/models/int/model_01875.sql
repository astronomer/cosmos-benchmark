{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00837') }},
        {{ ref('model_00957') }},
        {{ ref('model_00892') }}
)
select id, 'model_01875' as name from sources
