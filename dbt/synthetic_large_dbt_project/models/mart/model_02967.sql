{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02100') }}
)
select id, 'model_02967' as name from sources
