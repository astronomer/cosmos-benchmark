{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00249') }},
        {{ ref('model_00347') }}
)
select id, 'model_01023' as name from sources
