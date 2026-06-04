{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00587') }},
        {{ ref('model_00411') }}
)
select id, 'model_01419' as name from sources
