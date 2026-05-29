{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01401') }},
        {{ ref('model_00796') }}
)
select id, 'model_02188' as name from sources
