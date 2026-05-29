{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00870') }},
        {{ ref('model_01380') }}
)
select id, 'model_02105' as name from sources
