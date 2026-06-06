{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01552') }},
        {{ ref('model_01751') }}
)
select id, 'model_02774' as name from sources
