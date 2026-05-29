{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00139') }},
        {{ ref('model_00113') }}
)
select id, 'model_01308' as name from sources
