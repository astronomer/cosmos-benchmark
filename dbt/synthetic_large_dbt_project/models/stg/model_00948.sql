{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00328') }}
)
select id, 'model_00948' as name from sources
