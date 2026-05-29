{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00812') }},
        {{ ref('model_01460') }},
        {{ ref('model_00944') }}
)
select id, 'model_01854' as name from sources
