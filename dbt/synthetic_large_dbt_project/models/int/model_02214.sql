{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01391') }}
)
select id, 'model_02214' as name from sources
