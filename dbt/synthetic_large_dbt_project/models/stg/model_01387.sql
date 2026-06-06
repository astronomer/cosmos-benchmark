{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00363') }}
)
select id, 'model_01387' as name from sources
