{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01406') }},
        {{ ref('model_01439') }}
)
select id, 'model_01601' as name from sources
