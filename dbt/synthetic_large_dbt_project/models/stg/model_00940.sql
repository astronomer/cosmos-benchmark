{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00630') }},
        {{ ref('model_00677') }},
        {{ ref('model_00308') }}
)
select id, 'model_00940' as name from sources
