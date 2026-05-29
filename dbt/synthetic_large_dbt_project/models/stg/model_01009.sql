{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00102') }}
)
select id, 'model_01009' as name from sources
