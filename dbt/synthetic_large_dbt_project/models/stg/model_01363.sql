{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00710') }},
        {{ ref('model_00122') }}
)
select id, 'model_01363' as name from sources
