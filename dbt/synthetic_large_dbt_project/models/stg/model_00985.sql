{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00450') }}
)
select id, 'model_00985' as name from sources
