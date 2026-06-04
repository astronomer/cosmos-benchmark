{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01923') }}
)
select id, 'model_02884' as name from sources
