{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01838') }},
        {{ ref('model_01602') }}
)
select id, 'model_02806' as name from sources
