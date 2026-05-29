{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02134') }}
)
select id, 'model_02653' as name from sources
