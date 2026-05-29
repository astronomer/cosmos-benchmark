{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00390') }},
        {{ ref('model_00404') }}
)
select id, 'model_00957' as name from sources
