{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00687') }}
)
select id, 'model_01152' as name from sources
