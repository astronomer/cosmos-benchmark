{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01622') }},
        {{ ref('model_02166') }}
)
select id, 'model_02645' as name from sources
