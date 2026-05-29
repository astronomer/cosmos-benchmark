{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00180') }}
)
select id, 'model_00802' as name from sources
