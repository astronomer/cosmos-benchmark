{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00445') }},
        {{ ref('model_00536') }},
        {{ ref('model_00655') }}
)
select id, 'model_01061' as name from sources
