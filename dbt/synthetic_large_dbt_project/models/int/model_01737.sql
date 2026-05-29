{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01239') }}
)
select id, 'model_01737' as name from sources
