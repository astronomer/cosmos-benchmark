{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01945') }},
        {{ ref('model_01595') }}
)
select id, 'model_02282' as name from sources
