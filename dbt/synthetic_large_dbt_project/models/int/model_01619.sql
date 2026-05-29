{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01275') }},
        {{ ref('model_01417') }}
)
select id, 'model_01619' as name from sources
