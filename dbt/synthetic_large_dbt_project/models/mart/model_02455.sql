{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01757') }},
        {{ ref('model_01865') }},
        {{ ref('model_01585') }}
)
select id, 'model_02455' as name from sources
