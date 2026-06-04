{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00324') }},
        {{ ref('model_00135') }}
)
select id, 'model_00753' as name from sources
