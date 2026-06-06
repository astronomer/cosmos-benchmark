{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01790') }}
)
select id, 'model_02314' as name from sources
