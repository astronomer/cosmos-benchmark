{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00485') }}
)
select id, 'model_01332' as name from sources
