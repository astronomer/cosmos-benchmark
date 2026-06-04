{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01192') }},
        {{ ref('model_01218') }},
        {{ ref('model_01143') }}
)
select id, 'model_01676' as name from sources
