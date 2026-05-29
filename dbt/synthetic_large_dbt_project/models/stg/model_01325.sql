{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00719') }},
        {{ ref('model_00214') }},
        {{ ref('model_00230') }}
)
select id, 'model_01325' as name from sources
