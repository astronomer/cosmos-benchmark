{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00671') }}
)
select id, 'model_01483' as name from sources
