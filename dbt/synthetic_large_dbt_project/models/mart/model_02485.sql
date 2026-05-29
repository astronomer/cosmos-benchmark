{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01856') }},
        {{ ref('model_02234') }},
        {{ ref('model_02218') }}
)
select id, 'model_02485' as name from sources
