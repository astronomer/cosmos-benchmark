{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00967') }},
        {{ ref('model_00940') }},
        {{ ref('model_00955') }}
)
select id, 'model_01734' as name from sources
