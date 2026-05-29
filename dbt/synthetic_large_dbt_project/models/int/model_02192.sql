{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00800') }},
        {{ ref('model_01281') }},
        {{ ref('model_00965') }}
)
select id, 'model_02192' as name from sources
