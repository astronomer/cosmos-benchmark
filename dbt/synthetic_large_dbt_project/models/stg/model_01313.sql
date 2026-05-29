{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00587') }}
)
select id, 'model_01313' as name from sources
