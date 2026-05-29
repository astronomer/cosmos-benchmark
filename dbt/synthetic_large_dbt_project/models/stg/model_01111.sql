{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00255') }},
        {{ ref('model_00238') }},
        {{ ref('model_00262') }}
)
select id, 'model_01111' as name from sources
