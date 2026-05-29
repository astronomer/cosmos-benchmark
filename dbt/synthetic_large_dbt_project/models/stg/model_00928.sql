{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00690') }},
        {{ ref('model_00546') }}
)
select id, 'model_00928' as name from sources
