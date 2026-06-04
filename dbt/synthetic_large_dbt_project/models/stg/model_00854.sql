{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00226') }}
)
select id, 'model_00854' as name from sources
