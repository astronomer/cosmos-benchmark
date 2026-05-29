{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00632') }},
        {{ ref('model_00439') }}
)
select id, 'model_01457' as name from sources
