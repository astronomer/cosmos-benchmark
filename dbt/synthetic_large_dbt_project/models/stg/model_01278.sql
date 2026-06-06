{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00367') }},
        {{ ref('model_00498') }},
        {{ ref('model_00086') }}
)
select id, 'model_01278' as name from sources
