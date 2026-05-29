{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02056') }},
        {{ ref('model_01594') }}
)
select id, 'model_02686' as name from sources
