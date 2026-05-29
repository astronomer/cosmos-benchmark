{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01129') }},
        {{ ref('model_01474') }},
        {{ ref('model_01005') }}
)
select id, 'model_01808' as name from sources
