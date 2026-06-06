{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01439') }},
        {{ ref('model_01311') }}
)
select id, 'model_01750' as name from sources
