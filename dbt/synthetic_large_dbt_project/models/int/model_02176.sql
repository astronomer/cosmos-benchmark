{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01439') }}
)
select id, 'model_02176' as name from sources
