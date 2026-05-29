{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00182') }},
        {{ ref('model_00396') }}
)
select id, 'model_01306' as name from sources
