{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01412') }}
)
select id, 'model_02240' as name from sources
