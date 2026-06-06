{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01339') }}
)
select id, 'model_02151' as name from sources
