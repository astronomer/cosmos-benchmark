{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01965') }},
        {{ ref('model_01657') }},
        {{ ref('model_01572') }}
)
select id, 'model_02450' as name from sources
