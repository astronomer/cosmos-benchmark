{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00216') }}
)
select id, 'model_00882' as name from sources
