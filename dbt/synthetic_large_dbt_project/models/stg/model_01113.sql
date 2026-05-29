{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00719') }},
        {{ ref('model_00590') }},
        {{ ref('model_00097') }}
)
select id, 'model_01113' as name from sources
