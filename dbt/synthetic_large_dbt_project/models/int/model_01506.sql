{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00997') }},
        {{ ref('model_01196') }},
        {{ ref('model_01391') }}
)
select id, 'model_01506' as name from sources
