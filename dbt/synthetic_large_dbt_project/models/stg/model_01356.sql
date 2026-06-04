{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00424') }},
        {{ ref('model_00179') }}
)
select id, 'model_01356' as name from sources
