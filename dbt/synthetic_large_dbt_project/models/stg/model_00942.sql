{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00556') }},
        {{ ref('model_00549') }}
)
select id, 'model_00942' as name from sources
