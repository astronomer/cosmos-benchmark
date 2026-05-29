{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01199') }},
        {{ ref('model_00847') }},
        {{ ref('model_01390') }}
)
select id, 'model_01609' as name from sources
