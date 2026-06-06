{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01298') }}
)
select id, 'model_02189' as name from sources
