{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01914') }}
)
select id, 'model_02963' as name from sources
