{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01509') }},
        {{ ref('model_01631') }},
        {{ ref('model_02031') }}
)
select id, 'model_02410' as name from sources
