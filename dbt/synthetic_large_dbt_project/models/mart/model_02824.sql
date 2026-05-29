{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01707') }},
        {{ ref('model_02238') }}
)
select id, 'model_02824' as name from sources
