{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01099') }}
)
select id, 'model_02121' as name from sources
