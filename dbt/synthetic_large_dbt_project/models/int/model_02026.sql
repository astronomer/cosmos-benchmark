{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01044') }},
        {{ ref('model_00753') }},
        {{ ref('model_00846') }}
)
select id, 'model_02026' as name from sources
