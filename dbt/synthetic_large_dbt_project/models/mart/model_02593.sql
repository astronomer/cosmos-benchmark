{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01666') }}
)
select id, 'model_02593' as name from sources
