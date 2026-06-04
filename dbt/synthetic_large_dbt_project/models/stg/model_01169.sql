{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00509') }},
        {{ ref('model_00510') }}
)
select id, 'model_01169' as name from sources
