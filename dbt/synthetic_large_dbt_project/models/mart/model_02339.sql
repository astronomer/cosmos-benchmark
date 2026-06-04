{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01651') }}
)
select id, 'model_02339' as name from sources
