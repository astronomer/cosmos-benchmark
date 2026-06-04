{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01261') }}
)
select id, 'model_01944' as name from sources
