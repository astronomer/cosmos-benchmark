{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00125') }},
        {{ ref('model_00481') }},
        {{ ref('model_00726') }}
)
select id, 'model_01327' as name from sources
