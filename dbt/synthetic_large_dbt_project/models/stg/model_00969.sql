{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00339') }},
        {{ ref('model_00491') }},
        {{ ref('model_00473') }}
)
select id, 'model_00969' as name from sources
