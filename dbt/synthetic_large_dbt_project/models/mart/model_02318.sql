{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01871') }},
        {{ ref('model_02145') }}
)
select id, 'model_02318' as name from sources
