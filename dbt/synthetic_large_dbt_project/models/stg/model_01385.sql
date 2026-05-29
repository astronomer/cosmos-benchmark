{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00175') }},
        {{ ref('model_00550') }}
)
select id, 'model_01385' as name from sources
