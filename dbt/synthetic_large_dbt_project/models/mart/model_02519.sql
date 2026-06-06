{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02050') }},
        {{ ref('model_01553') }}
)
select id, 'model_02519' as name from sources
