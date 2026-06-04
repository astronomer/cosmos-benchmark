{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00947') }},
        {{ ref('model_01381') }}
)
select id, 'model_01962' as name from sources
