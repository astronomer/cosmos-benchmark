{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00366') }},
        {{ ref('model_00212') }},
        {{ ref('model_00462') }}
)
select id, 'model_00784' as name from sources
