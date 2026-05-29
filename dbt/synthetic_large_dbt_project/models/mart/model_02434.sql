{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01623') }}
)
select id, 'model_02434' as name from sources
