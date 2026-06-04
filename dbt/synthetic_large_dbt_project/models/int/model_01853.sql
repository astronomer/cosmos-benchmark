{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00772') }},
        {{ ref('model_00920') }},
        {{ ref('model_01363') }}
)
select id, 'model_01853' as name from sources
