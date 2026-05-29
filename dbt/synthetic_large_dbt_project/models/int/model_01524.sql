{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01023') }},
        {{ ref('model_00904') }},
        {{ ref('model_01456') }}
)
select id, 'model_01524' as name from sources
