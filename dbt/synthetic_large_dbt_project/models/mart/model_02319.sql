{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01825') }},
        {{ ref('model_02014') }},
        {{ ref('model_02048') }}
)
select id, 'model_02319' as name from sources
