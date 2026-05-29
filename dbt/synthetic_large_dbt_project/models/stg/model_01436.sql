{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00680') }},
        {{ ref('model_00594') }},
        {{ ref('model_00537') }}
)
select id, 'model_01436' as name from sources
