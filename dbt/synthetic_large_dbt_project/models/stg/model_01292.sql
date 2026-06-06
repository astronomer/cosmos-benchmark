{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00082') }},
        {{ ref('model_00006') }}
)
select id, 'model_01292' as name from sources
