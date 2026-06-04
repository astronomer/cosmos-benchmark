{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01134') }}
)
select id, 'model_01739' as name from sources
