{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00550') }},
        {{ ref('model_00588') }}
)
select id, 'model_01022' as name from sources
