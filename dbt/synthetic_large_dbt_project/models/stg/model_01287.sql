{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00436') }}
)
select id, 'model_01287' as name from sources
