{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00053') }}
)
select id, 'model_01253' as name from sources
