{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02098') }}
)
select id, 'model_02395' as name from sources
