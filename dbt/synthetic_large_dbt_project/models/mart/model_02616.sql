{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02000') }}
)
select id, 'model_02616' as name from sources
