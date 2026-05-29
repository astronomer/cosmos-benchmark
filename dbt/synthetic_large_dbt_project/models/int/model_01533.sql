{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01448') }},
        {{ ref('model_01120') }},
        {{ ref('model_00780') }}
)
select id, 'model_01533' as name from sources
