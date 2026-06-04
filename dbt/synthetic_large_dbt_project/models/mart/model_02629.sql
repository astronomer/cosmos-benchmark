{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02237') }},
        {{ ref('model_01884') }}
)
select id, 'model_02629' as name from sources
