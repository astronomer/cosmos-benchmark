{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02185') }}
)
select id, 'model_02789' as name from sources
