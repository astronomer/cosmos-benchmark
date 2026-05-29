{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01622') }},
        {{ ref('model_01729') }},
        {{ ref('model_02143') }}
)
select id, 'model_02544' as name from sources
