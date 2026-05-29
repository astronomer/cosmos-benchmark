{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00689') }},
        {{ ref('model_00506') }}
)
select id, 'model_01459' as name from sources
