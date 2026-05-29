{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00778') }}
)
select id, 'model_01967' as name from sources
