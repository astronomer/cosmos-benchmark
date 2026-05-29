{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00802') }},
        {{ ref('model_01061') }},
        {{ ref('model_00862') }}
)
select id, 'model_01842' as name from sources
