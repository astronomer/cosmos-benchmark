{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01955') }},
        {{ ref('model_01890') }}
)
select id, 'model_02654' as name from sources
