{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00370') }},
        {{ ref('model_00595') }},
        {{ ref('model_00492') }}
)
select id, 'model_01362' as name from sources
