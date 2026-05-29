{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00055') }},
        {{ ref('model_00011') }},
        {{ ref('model_00658') }}
)
select id, 'model_00905' as name from sources
