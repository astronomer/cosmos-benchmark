{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00044') }},
        {{ ref('model_00106') }}
)
select id, 'model_01301' as name from sources
