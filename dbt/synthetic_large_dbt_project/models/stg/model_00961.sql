{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00352') }},
        {{ ref('model_00216') }},
        {{ ref('model_00422') }}
)
select id, 'model_00961' as name from sources
