{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01176') }},
        {{ ref('model_01439') }}
)
select id, 'model_01517' as name from sources
