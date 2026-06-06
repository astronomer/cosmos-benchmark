{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01942') }},
        {{ ref('model_02185') }},
        {{ ref('model_01526') }}
)
select id, 'model_02462' as name from sources
