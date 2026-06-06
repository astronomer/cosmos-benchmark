{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01547') }},
        {{ ref('model_02031') }}
)
select id, 'model_02979' as name from sources
