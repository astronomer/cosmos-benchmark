{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02052') }},
        {{ ref('model_01749') }},
        {{ ref('model_02210') }}
)
select id, 'model_02302' as name from sources
