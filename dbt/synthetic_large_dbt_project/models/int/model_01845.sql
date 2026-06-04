{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01008') }}
)
select id, 'model_01845' as name from sources
