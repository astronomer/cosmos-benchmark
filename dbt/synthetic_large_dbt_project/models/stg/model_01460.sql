{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00294') }},
        {{ ref('model_00506') }}
)
select id, 'model_01460' as name from sources
