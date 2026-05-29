{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00355') }},
        {{ ref('model_00449') }},
        {{ ref('model_00197') }}
)
select id, 'model_01086' as name from sources
