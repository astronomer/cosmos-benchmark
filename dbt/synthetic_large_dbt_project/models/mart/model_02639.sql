{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01905') }},
        {{ ref('model_01519') }},
        {{ ref('model_02022') }}
)
select id, 'model_02639' as name from sources
