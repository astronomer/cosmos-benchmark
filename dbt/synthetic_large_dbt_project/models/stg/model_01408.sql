{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00487') }},
        {{ ref('model_00575') }}
)
select id, 'model_01408' as name from sources
