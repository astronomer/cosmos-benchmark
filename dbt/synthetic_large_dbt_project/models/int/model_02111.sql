{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01204') }}
)
select id, 'model_02111' as name from sources
