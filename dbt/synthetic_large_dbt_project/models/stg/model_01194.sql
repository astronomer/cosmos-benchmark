{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00722') }},
        {{ ref('model_00322') }}
)
select id, 'model_01194' as name from sources
