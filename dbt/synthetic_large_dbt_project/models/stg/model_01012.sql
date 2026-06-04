{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00379') }}
)
select id, 'model_01012' as name from sources
