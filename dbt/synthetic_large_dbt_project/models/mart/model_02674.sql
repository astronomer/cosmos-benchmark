{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01668') }},
        {{ ref('model_01732') }},
        {{ ref('model_02200') }}
)
select id, 'model_02674' as name from sources
