{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00140') }},
        {{ ref('model_00089') }},
        {{ ref('model_00747') }}
)
select id, 'model_01140' as name from sources
