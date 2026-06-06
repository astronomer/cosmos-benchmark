{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00831') }},
        {{ ref('model_01110') }}
)
select id, 'model_02147' as name from sources
