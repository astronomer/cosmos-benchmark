{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00868') }}
)
select id, 'model_01758' as name from sources
