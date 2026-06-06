{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00307') }},
        {{ ref('model_00518') }}
)
select id, 'model_01186' as name from sources
