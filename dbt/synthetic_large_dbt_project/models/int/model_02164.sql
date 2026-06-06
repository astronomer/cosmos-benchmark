{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01071') }},
        {{ ref('model_00851') }},
        {{ ref('model_01105') }}
)
select id, 'model_02164' as name from sources
