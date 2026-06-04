{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01672') }}
)
select id, 'model_02471' as name from sources
