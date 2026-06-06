{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01004') }},
        {{ ref('model_00863') }},
        {{ ref('model_00974') }}
)
select id, 'model_02022' as name from sources
