{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01210') }},
        {{ ref('model_01404') }},
        {{ ref('model_01342') }}
)
select id, 'model_01946' as name from sources
