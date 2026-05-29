{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01380') }},
        {{ ref('model_01434') }}
)
select id, 'model_02228' as name from sources
