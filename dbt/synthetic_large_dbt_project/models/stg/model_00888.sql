{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00632') }},
        {{ ref('model_00120') }},
        {{ ref('model_00289') }}
)
select id, 'model_00888' as name from sources
