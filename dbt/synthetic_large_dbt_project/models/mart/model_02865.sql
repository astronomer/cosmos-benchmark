{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02173') }}
)
select id, 'model_02865' as name from sources
