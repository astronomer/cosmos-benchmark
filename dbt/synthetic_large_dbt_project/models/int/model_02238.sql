{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01202') }}
)
select id, 'model_02238' as name from sources
