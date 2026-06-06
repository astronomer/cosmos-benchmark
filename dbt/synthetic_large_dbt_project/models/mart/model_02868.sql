{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01583') }}
)
select id, 'model_02868' as name from sources
