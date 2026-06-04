{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00038') }}
)
select id, 'model_01238' as name from sources
