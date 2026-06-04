{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00783') }},
        {{ ref('model_00910') }}
)
select id, 'model_01555' as name from sources
