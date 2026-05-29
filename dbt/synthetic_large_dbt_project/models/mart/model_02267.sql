{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01908') }},
        {{ ref('model_01984') }},
        {{ ref('model_01749') }}
)
select id, 'model_02267' as name from sources
