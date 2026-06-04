{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01848') }},
        {{ ref('model_01622') }},
        {{ ref('model_02139') }}
)
select id, 'model_02855' as name from sources
