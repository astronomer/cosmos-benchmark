{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01615') }}
)
select id, 'model_02705' as name from sources
