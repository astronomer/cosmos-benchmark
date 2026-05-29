{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01523') }},
        {{ ref('model_01526') }}
)
select id, 'model_02859' as name from sources
