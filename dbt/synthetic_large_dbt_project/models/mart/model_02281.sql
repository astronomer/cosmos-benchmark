{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01907') }},
        {{ ref('model_01579') }},
        {{ ref('model_02161') }}
)
select id, 'model_02281' as name from sources
