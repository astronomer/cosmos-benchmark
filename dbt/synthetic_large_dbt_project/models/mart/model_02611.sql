{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01788') }},
        {{ ref('model_01849') }},
        {{ ref('model_02242') }}
)
select id, 'model_02611' as name from sources
