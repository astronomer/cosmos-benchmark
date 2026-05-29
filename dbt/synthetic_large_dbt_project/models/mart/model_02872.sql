{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01897') }},
        {{ ref('model_01697') }},
        {{ ref('model_02040') }}
)
select id, 'model_02872' as name from sources
