{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01876') }},
        {{ ref('model_02087') }},
        {{ ref('model_01785') }}
)
select id, 'model_02763' as name from sources
