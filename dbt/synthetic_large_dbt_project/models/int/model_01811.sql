{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01399') }}
)
select id, 'model_01811' as name from sources
