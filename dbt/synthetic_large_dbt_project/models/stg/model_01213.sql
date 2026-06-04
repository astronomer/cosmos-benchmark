{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00264') }},
        {{ ref('model_00372') }},
        {{ ref('model_00401') }}
)
select id, 'model_01213' as name from sources
