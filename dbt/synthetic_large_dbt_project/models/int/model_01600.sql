{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01444') }},
        {{ ref('model_01295') }},
        {{ ref('model_01379') }}
)
select id, 'model_01600' as name from sources
