{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00572') }}
)
select id, 'model_01468' as name from sources
