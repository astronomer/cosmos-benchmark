{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01828') }}
)
select id, 'model_02982' as name from sources
