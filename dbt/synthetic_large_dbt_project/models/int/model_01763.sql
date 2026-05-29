{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00899') }},
        {{ ref('model_01431') }}
)
select id, 'model_01763' as name from sources
