{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00205') }}
)
select id, 'model_00925' as name from sources
