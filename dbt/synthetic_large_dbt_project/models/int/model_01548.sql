{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01438') }},
        {{ ref('model_00893') }},
        {{ ref('model_01481') }}
)
select id, 'model_01548' as name from sources
