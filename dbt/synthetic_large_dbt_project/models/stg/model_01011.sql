{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00148') }}
)
select id, 'model_01011' as name from sources
