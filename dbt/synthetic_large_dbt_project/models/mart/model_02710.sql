{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01870') }},
        {{ ref('model_01730') }},
        {{ ref('model_01768') }}
)
select id, 'model_02710' as name from sources
