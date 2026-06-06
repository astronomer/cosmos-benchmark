{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02173') }},
        {{ ref('model_02238') }}
)
select id, 'model_02539' as name from sources
