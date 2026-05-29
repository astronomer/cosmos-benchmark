{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00599') }},
        {{ ref('model_00311') }}
)
select id, 'model_01358' as name from sources
