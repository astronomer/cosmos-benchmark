{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00754') }},
        {{ ref('model_01222') }},
        {{ ref('model_01041') }}
)
select id, 'model_01997' as name from sources
