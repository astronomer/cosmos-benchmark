{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00494') }},
        {{ ref('model_00637') }},
        {{ ref('model_00747') }}
)
select id, 'model_01130' as name from sources
