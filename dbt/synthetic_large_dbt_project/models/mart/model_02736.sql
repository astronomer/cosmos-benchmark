{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02065') }},
        {{ ref('model_01862') }}
)
select id, 'model_02736' as name from sources
