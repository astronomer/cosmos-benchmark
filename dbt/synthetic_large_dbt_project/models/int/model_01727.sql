{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01473') }},
        {{ ref('model_01350') }}
)
select id, 'model_01727' as name from sources
