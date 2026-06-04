{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01071') }}
)
select id, 'model_02245' as name from sources
