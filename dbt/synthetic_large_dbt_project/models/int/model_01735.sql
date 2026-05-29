{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01168') }},
        {{ ref('model_01201') }}
)
select id, 'model_01735' as name from sources
