{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00270') }},
        {{ ref('model_00475') }}
)
select id, 'model_00893' as name from sources
