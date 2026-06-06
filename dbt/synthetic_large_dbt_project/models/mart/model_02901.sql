{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01723') }}
)
select id, 'model_02901' as name from sources
