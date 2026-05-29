{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00306') }},
        {{ ref('model_00718') }},
        {{ ref('model_00560') }}
)
select id, 'model_00924' as name from sources
