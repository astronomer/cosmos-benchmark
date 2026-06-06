{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01362') }},
        {{ ref('model_01006') }}
)
select id, 'model_01583' as name from sources
