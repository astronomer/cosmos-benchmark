{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01246') }},
        {{ ref('model_01251') }},
        {{ ref('model_01395') }}
)
select id, 'model_02181' as name from sources
