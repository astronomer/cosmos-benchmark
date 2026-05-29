{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00628') }},
        {{ ref('model_00713') }},
        {{ ref('model_00700') }}
)
select id, 'model_01010' as name from sources
