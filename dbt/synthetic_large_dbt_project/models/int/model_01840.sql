{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01139') }}
)
select id, 'model_01840' as name from sources
