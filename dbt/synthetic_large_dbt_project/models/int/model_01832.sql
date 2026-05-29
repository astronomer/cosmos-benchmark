{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00884') }},
        {{ ref('model_00862') }}
)
select id, 'model_01832' as name from sources
