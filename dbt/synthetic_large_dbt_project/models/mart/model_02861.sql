{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01770') }}
)
select id, 'model_02861' as name from sources
