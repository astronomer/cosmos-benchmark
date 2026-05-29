{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00252') }},
        {{ ref('model_00253') }},
        {{ ref('model_00335') }}
)
select id, 'model_01312' as name from sources
