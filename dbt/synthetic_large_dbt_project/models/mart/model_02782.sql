{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02026') }},
        {{ ref('model_01537') }}
)
select id, 'model_02782' as name from sources
