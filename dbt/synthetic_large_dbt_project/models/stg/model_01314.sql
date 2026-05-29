{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00516') }},
        {{ ref('model_00034') }}
)
select id, 'model_01314' as name from sources
