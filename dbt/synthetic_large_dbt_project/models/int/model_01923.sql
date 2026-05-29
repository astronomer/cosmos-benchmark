{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00819') }}
)
select id, 'model_01923' as name from sources
