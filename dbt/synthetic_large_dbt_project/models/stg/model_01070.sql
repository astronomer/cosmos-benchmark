{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00463') }},
        {{ ref('model_00278') }},
        {{ ref('model_00717') }}
)
select id, 'model_01070' as name from sources
