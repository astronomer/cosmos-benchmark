{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01769') }}
)
select id, 'model_02591' as name from sources
