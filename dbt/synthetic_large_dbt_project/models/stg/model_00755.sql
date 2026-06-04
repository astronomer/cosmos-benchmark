{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00040') }}
)
select id, 'model_00755' as name from sources
