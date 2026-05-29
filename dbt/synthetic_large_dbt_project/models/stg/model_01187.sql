{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00349') }},
        {{ ref('model_00405') }}
)
select id, 'model_01187' as name from sources
