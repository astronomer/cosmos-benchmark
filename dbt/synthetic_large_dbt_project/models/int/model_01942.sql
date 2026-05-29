{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01324') }}
)
select id, 'model_01942' as name from sources
