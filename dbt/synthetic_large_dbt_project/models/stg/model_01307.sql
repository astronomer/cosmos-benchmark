{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00276') }},
        {{ ref('model_00207') }}
)
select id, 'model_01307' as name from sources
