{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01214') }}
)
select id, 'model_01615' as name from sources
