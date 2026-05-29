{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00276') }},
        {{ ref('model_00637') }},
        {{ ref('model_00620') }}
)
select id, 'model_00887' as name from sources
