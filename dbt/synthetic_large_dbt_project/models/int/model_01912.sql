{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01039') }},
        {{ ref('model_01157') }}
)
select id, 'model_01912' as name from sources
