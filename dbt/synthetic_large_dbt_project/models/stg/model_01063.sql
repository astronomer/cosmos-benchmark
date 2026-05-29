{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00010') }},
        {{ ref('model_00000') }}
)
select id, 'model_01063' as name from sources
