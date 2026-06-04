{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00610') }},
        {{ ref('model_00606') }},
        {{ ref('model_00644') }}
)
select id, 'model_01209' as name from sources
