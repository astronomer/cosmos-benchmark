{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00097') }},
        {{ ref('model_00606') }},
        {{ ref('model_00344') }}
)
select id, 'model_01420' as name from sources
