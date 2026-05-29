{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01340') }},
        {{ ref('model_01151') }},
        {{ ref('model_01392') }}
)
select id, 'model_01965' as name from sources
