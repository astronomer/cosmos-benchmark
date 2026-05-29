{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01346') }},
        {{ ref('model_00947') }},
        {{ ref('model_01119') }}
)
select id, 'model_01549' as name from sources
