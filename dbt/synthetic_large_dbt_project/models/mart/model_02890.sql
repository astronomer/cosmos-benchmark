{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01913') }},
        {{ ref('model_01520') }}
)
select id, 'model_02890' as name from sources
