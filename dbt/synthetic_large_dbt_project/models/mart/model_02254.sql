{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01752') }},
        {{ ref('model_01815') }},
        {{ ref('model_02197') }}
)
select id, 'model_02254' as name from sources
