{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00676') }}
)
select id, 'model_00987' as name from sources
