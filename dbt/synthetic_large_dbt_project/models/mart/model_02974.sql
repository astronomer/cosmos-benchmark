{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02240') }}
)
select id, 'model_02974' as name from sources
