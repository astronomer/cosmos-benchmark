{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00830') }},
        {{ ref('model_01369') }},
        {{ ref('model_00969') }}
)
select id, 'model_02233' as name from sources
