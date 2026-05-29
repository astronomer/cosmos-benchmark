{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00768') }}
)
select id, 'model_01685' as name from sources
