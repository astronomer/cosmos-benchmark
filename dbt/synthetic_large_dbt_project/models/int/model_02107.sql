{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01299') }},
        {{ ref('model_01331') }},
        {{ ref('model_00796') }}
)
select id, 'model_02107' as name from sources
