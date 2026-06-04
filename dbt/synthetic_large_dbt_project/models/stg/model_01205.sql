{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00573') }},
        {{ ref('model_00526') }},
        {{ ref('model_00104') }}
)
select id, 'model_01205' as name from sources
