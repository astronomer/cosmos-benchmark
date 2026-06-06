{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00231') }},
        {{ ref('model_00567') }}
)
select id, 'model_01391' as name from sources
