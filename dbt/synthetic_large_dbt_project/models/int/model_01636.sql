{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00883') }}
)
select id, 'model_01636' as name from sources
