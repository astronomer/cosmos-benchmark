{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00427') }}
)
select id, 'model_01373' as name from sources
