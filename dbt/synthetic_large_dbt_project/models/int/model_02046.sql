{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00801') }}
)
select id, 'model_02046' as name from sources
