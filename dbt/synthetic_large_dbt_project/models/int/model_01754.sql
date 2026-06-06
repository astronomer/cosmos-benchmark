{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00876') }},
        {{ ref('model_01431') }},
        {{ ref('model_00889') }}
)
select id, 'model_01754' as name from sources
