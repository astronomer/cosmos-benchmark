{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01271') }},
        {{ ref('model_01133') }},
        {{ ref('model_01260') }}
)
select id, 'model_01641' as name from sources
