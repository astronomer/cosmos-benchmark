{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00543') }},
        {{ ref('model_00033') }}
)
select id, 'model_01320' as name from sources
