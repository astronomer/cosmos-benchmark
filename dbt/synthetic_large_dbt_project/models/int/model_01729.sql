{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01141') }},
        {{ ref('model_01350') }},
        {{ ref('model_01065') }}
)
select id, 'model_01729' as name from sources
