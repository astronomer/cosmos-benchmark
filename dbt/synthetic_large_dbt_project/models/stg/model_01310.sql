{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00174') }},
        {{ ref('model_00591') }},
        {{ ref('model_00566') }}
)
select id, 'model_01310' as name from sources
