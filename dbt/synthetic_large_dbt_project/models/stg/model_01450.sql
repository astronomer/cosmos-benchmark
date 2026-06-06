{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00656') }},
        {{ ref('model_00139') }}
)
select id, 'model_01450' as name from sources
