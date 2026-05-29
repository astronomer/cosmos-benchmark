{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01045') }},
        {{ ref('model_00862') }}
)
select id, 'model_02042' as name from sources
