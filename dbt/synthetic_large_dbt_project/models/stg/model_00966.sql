{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00461') }},
        {{ ref('model_00336') }}
)
select id, 'model_00966' as name from sources
