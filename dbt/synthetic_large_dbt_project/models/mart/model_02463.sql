{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01601') }},
        {{ ref('model_01799') }}
)
select id, 'model_02463' as name from sources
