{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01692') }},
        {{ ref('model_02127') }},
        {{ ref('model_01642') }}
)
select id, 'model_02723' as name from sources
