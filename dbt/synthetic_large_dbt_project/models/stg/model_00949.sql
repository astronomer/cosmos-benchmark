{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00546') }},
        {{ ref('model_00007') }},
        {{ ref('model_00641') }}
)
select id, 'model_00949' as name from sources
