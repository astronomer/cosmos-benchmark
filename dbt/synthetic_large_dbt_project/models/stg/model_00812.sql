{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00130') }},
        {{ ref('model_00181') }}
)
select id, 'model_00812' as name from sources
