{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01718') }},
        {{ ref('model_02046') }},
        {{ ref('model_02177') }}
)
select id, 'model_02836' as name from sources
