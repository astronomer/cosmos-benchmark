{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01415') }},
        {{ ref('model_00893') }}
)
select id, 'model_01925' as name from sources
