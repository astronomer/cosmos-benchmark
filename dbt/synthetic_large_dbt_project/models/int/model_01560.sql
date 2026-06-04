{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01177') }}
)
select id, 'model_01560' as name from sources
