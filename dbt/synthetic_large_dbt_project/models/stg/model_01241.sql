{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00645') }},
        {{ ref('model_00679') }}
)
select id, 'model_01241' as name from sources
