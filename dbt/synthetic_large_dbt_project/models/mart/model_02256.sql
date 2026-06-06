{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01731') }},
        {{ ref('model_01692') }}
)
select id, 'model_02256' as name from sources
