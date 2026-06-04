{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00980') }},
        {{ ref('model_00773') }},
        {{ ref('model_01350') }}
)
select id, 'model_01780' as name from sources
