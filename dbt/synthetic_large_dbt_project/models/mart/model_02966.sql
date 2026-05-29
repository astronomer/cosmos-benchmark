{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02237') }},
        {{ ref('model_02037') }},
        {{ ref('model_01508') }}
)
select id, 'model_02966' as name from sources
