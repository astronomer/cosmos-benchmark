{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00042') }},
        {{ ref('model_00099') }},
        {{ ref('model_00544') }}
)
select id, 'model_01256' as name from sources
