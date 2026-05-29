{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00596') }},
        {{ ref('model_00356') }},
        {{ ref('model_00355') }}
)
select id, 'model_01019' as name from sources
