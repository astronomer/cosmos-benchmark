{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00580') }},
        {{ ref('model_00350') }}
)
select id, 'model_01219' as name from sources
