{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00635') }},
        {{ ref('model_00376') }}
)
select id, 'model_01328' as name from sources
