{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00934') }},
        {{ ref('model_01174') }}
)
select id, 'model_01571' as name from sources
