{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01662') }},
        {{ ref('model_01594') }},
        {{ ref('model_02130') }}
)
select id, 'model_02753' as name from sources
