{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00912') }},
        {{ ref('model_01368') }}
)
select id, 'model_01671' as name from sources
