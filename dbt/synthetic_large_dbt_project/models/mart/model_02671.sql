{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01648') }},
        {{ ref('model_02113') }},
        {{ ref('model_01849') }}
)
select id, 'model_02671' as name from sources
