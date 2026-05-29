{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02017') }},
        {{ ref('model_01523') }},
        {{ ref('model_01731') }}
)
select id, 'model_02955' as name from sources
