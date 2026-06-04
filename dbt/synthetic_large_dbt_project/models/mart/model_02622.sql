{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01692') }},
        {{ ref('model_02111') }},
        {{ ref('model_02119') }}
)
select id, 'model_02622' as name from sources
