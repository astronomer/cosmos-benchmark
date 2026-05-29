{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02177') }},
        {{ ref('model_01550') }}
)
select id, 'model_02939' as name from sources
