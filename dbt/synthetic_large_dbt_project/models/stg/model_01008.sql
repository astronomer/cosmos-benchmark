{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00675') }}
)
select id, 'model_01008' as name from sources
