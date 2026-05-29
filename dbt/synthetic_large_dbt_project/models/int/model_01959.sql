{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01064') }},
        {{ ref('model_01174') }}
)
select id, 'model_01959' as name from sources
