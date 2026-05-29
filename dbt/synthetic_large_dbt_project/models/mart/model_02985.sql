{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02136') }}
)
select id, 'model_02985' as name from sources
