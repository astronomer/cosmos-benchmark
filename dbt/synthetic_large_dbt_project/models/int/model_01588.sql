{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01411') }}
)
select id, 'model_01588' as name from sources
