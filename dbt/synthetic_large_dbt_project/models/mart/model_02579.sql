{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01536') }},
        {{ ref('model_02211') }}
)
select id, 'model_02579' as name from sources
