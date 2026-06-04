{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00686') }},
        {{ ref('model_00460') }}
)
select id, 'model_01499' as name from sources
