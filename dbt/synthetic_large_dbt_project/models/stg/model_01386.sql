{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00724') }},
        {{ ref('model_00486') }},
        {{ ref('model_00375') }}
)
select id, 'model_01386' as name from sources
