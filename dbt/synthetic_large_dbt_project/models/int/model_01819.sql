{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01005') }},
        {{ ref('model_01302') }},
        {{ ref('model_00870') }}
)
select id, 'model_01819' as name from sources
