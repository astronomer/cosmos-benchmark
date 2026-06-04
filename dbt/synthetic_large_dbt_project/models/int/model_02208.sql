{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01490') }},
        {{ ref('model_01330') }},
        {{ ref('model_00988') }}
)
select id, 'model_02208' as name from sources
