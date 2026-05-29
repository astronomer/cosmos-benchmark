{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02199') }},
        {{ ref('model_01691') }},
        {{ ref('model_01800') }}
)
select id, 'model_02953' as name from sources
