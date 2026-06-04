{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01413') }},
        {{ ref('model_00854') }},
        {{ ref('model_00900') }}
)
select id, 'model_02016' as name from sources
