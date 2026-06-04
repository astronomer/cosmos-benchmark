{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00091') }}
)
select id, 'model_01062' as name from sources
