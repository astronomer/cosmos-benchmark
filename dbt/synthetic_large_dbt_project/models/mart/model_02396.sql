{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01863') }},
        {{ ref('model_02232') }},
        {{ ref('model_02090') }}
)
select id, 'model_02396' as name from sources
