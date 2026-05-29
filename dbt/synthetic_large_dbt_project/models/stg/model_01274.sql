{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00493') }},
        {{ ref('model_00124') }},
        {{ ref('model_00580') }}
)
select id, 'model_01274' as name from sources
