{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01004') }},
        {{ ref('model_01444') }}
)
select id, 'model_02049' as name from sources
