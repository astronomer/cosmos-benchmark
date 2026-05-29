{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01888') }},
        {{ ref('model_01980') }}
)
select id, 'model_02935' as name from sources
