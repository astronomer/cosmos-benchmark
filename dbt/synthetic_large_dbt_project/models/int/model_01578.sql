{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01398') }},
        {{ ref('model_00989') }}
)
select id, 'model_01578' as name from sources
