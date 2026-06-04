{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01214') }}
)
select id, 'model_02152' as name from sources
