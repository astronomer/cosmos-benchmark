{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01359') }},
        {{ ref('model_00989') }},
        {{ ref('model_01108') }}
)
select id, 'model_01547' as name from sources
