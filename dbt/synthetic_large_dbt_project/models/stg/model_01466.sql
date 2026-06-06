{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00362') }},
        {{ ref('model_00620') }}
)
select id, 'model_01466' as name from sources
