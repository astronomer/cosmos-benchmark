{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01270') }}
)
select id, 'model_01639' as name from sources
