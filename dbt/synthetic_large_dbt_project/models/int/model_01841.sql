{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00977') }}
)
select id, 'model_01841' as name from sources
