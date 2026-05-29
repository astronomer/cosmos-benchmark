{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01046') }},
        {{ ref('model_01238') }}
)
select id, 'model_02158' as name from sources
