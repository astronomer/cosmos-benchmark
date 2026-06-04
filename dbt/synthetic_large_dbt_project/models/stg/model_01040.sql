{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00276') }},
        {{ ref('model_00241') }},
        {{ ref('model_00568') }}
)
select id, 'model_01040' as name from sources
