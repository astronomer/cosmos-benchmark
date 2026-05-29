{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02226') }},
        {{ ref('model_01788') }}
)
select id, 'model_02662' as name from sources
