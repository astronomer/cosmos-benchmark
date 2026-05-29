{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00347') }},
        {{ ref('model_00479') }}
)
select id, 'model_01469' as name from sources
