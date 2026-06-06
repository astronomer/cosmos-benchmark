{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01510') }}
)
select id, 'model_02253' as name from sources
