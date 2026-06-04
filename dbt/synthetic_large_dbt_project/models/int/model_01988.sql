{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01110') }},
        {{ ref('model_01157') }},
        {{ ref('model_00780') }}
)
select id, 'model_01988' as name from sources
