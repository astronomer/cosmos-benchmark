{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01073') }},
        {{ ref('model_00755') }}
)
select id, 'model_01604' as name from sources
