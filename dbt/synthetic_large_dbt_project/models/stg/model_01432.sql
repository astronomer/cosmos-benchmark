{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00284') }},
        {{ ref('model_00674') }}
)
select id, 'model_01432' as name from sources
