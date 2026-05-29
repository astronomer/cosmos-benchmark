{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01801') }}
)
select id, 'model_02998' as name from sources
