{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00101') }}
)
select id, 'model_01384' as name from sources
