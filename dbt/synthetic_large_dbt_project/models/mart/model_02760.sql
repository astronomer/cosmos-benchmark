{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01656') }}
)
select id, 'model_02760' as name from sources
