{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00681') }},
        {{ ref('model_00437') }},
        {{ ref('model_00106') }}
)
select id, 'model_01103' as name from sources
