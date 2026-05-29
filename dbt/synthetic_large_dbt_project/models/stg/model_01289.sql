{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00064') }},
        {{ ref('model_00123') }}
)
select id, 'model_01289' as name from sources
