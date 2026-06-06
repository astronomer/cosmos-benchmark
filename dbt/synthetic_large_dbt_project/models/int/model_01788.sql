{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00836') }}
)
select id, 'model_01788' as name from sources
