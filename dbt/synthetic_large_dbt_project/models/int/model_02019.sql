{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01191') }},
        {{ ref('model_01270') }},
        {{ ref('model_01091') }}
)
select id, 'model_02019' as name from sources
