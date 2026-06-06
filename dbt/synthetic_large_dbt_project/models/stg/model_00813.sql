{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00033') }},
        {{ ref('model_00186') }},
        {{ ref('model_00616') }}
)
select id, 'model_00813' as name from sources
