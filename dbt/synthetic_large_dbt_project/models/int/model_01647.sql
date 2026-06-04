{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01228') }},
        {{ ref('model_01192') }}
)
select id, 'model_01647' as name from sources
