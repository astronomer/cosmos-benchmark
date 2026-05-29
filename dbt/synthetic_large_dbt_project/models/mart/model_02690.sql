{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01528') }},
        {{ ref('model_02018') }},
        {{ ref('model_01955') }}
)
select id, 'model_02690' as name from sources
