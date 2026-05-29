{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02188') }},
        {{ ref('model_02226') }},
        {{ ref('model_02118') }}
)
select id, 'model_02460' as name from sources
