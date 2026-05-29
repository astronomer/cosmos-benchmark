{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01780') }},
        {{ ref('model_01519') }}
)
select id, 'model_02373' as name from sources
