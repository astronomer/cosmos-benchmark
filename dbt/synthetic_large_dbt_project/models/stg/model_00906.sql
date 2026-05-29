{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00076') }}
)
select id, 'model_00906' as name from sources
