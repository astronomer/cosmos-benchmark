{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00400') }}
)
select id, 'model_01329' as name from sources
