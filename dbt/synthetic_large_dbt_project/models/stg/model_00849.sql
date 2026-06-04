{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00029') }},
        {{ ref('model_00177') }},
        {{ ref('model_00197') }}
)
select id, 'model_00849' as name from sources
