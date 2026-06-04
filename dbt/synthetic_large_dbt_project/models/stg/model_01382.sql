{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00029') }},
        {{ ref('model_00092') }}
)
select id, 'model_01382' as name from sources
