{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00067') }},
        {{ ref('model_00152') }}
)
select id, 'model_01192' as name from sources
