{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00631') }},
        {{ ref('model_00501') }}
)
select id, 'model_01153' as name from sources
