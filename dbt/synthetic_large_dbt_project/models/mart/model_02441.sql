{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01910') }}
)
select id, 'model_02441' as name from sources
