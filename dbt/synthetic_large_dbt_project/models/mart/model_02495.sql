{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02246') }},
        {{ ref('model_01622') }}
)
select id, 'model_02495' as name from sources
