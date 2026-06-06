{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00614') }}
)
select id, 'model_00862' as name from sources
