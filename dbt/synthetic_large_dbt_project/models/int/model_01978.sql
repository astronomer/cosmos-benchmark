{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01010') }},
        {{ ref('model_00874') }},
        {{ ref('model_00947') }}
)
select id, 'model_01978' as name from sources
