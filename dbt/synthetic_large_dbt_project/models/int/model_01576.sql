{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01350') }},
        {{ ref('model_00992') }},
        {{ ref('model_01254') }}
)
select id, 'model_01576' as name from sources
