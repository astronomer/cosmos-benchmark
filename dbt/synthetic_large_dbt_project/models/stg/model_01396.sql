{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00125') }},
        {{ ref('model_00238') }}
)
select id, 'model_01396' as name from sources
