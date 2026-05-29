{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00611') }},
        {{ ref('model_00535') }}
)
select id, 'model_01375' as name from sources
