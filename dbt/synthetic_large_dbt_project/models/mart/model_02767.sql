{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01862') }},
        {{ ref('model_02120') }},
        {{ ref('model_02091') }}
)
select id, 'model_02767' as name from sources
