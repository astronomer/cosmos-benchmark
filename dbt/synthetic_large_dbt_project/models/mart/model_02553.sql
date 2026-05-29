{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01699') }},
        {{ ref('model_02246') }},
        {{ ref('model_02175') }}
)
select id, 'model_02553' as name from sources
