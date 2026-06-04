{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02215') }}
)
select id, 'model_02925' as name from sources
