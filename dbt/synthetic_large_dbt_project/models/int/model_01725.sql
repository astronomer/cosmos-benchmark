{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01216') }},
        {{ ref('model_01447') }},
        {{ ref('model_00900') }}
)
select id, 'model_01725' as name from sources
