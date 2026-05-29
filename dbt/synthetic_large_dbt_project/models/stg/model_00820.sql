{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00174') }},
        {{ ref('model_00384') }}
)
select id, 'model_00820' as name from sources
