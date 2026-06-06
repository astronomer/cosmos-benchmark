{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00763') }},
        {{ ref('model_01111') }}
)
select id, 'model_02034' as name from sources
