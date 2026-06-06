{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01593') }}
)
select id, 'model_02738' as name from sources
