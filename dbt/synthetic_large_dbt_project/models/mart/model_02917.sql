{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01935') }},
        {{ ref('model_01676') }}
)
select id, 'model_02917' as name from sources
