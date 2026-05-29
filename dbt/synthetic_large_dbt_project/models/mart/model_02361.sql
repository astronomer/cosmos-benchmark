{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02019') }},
        {{ ref('model_01994') }}
)
select id, 'model_02361' as name from sources
