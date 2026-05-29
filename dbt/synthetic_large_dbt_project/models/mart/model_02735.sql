{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01940') }},
        {{ ref('model_01746') }}
)
select id, 'model_02735' as name from sources
