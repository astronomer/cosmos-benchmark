{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01081') }}
)
select id, 'model_02230' as name from sources
