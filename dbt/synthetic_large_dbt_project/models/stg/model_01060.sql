{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00552') }},
        {{ ref('model_00181') }},
        {{ ref('model_00605') }}
)
select id, 'model_01060' as name from sources
