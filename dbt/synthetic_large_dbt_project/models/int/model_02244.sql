{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00931') }},
        {{ ref('model_00884') }},
        {{ ref('model_00834') }}
)
select id, 'model_02244' as name from sources
