{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00743') }}
)
select id, 'model_00964' as name from sources
