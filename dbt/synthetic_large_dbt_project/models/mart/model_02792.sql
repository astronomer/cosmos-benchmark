{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02103') }},
        {{ ref('model_02032') }},
        {{ ref('model_02198') }}
)
select id, 'model_02792' as name from sources
