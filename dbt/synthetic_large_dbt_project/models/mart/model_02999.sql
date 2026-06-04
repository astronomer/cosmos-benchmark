{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01917') }}
)
select id, 'model_02999' as name from sources
