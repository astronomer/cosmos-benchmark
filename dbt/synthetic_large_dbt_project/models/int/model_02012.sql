{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01249') }}
)
select id, 'model_02012' as name from sources
