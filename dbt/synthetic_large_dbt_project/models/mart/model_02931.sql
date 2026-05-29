{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02119') }},
        {{ ref('model_01526') }},
        {{ ref('model_02236') }}
)
select id, 'model_02931' as name from sources
