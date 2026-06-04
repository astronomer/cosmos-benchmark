{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01988') }},
        {{ ref('model_01975') }},
        {{ ref('model_01600') }}
)
select id, 'model_02356' as name from sources
