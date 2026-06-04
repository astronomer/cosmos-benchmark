{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01147') }},
        {{ ref('model_01444') }},
        {{ ref('model_01460') }}
)
select id, 'model_01699' as name from sources
