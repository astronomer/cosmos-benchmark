{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00691') }},
        {{ ref('model_00247') }}
)
select id, 'model_01258' as name from sources
