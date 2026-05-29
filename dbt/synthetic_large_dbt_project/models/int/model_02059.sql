{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00859') }},
        {{ ref('model_01091') }},
        {{ ref('model_01358') }}
)
select id, 'model_02059' as name from sources
