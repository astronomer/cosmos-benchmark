{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00192') }},
        {{ ref('model_00070') }}
)
select id, 'model_01069' as name from sources
