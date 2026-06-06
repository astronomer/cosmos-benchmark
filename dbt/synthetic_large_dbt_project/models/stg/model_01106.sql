{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00219') }},
        {{ ref('model_00384') }},
        {{ ref('model_00563') }}
)
select id, 'model_01106' as name from sources
