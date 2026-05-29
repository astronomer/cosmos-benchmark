{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00589') }},
        {{ ref('model_00558') }},
        {{ ref('model_00140') }}
)
select id, 'model_01288' as name from sources
