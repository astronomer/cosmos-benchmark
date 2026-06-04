{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01068') }},
        {{ ref('model_00814') }}
)
select id, 'model_01606' as name from sources
