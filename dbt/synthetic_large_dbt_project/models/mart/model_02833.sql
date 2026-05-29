{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01541') }}
)
select id, 'model_02833' as name from sources
