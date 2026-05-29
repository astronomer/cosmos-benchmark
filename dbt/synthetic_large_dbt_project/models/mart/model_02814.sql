{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01581') }}
)
select id, 'model_02814' as name from sources
