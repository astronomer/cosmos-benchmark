{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01936') }},
        {{ ref('model_01913') }},
        {{ ref('model_01945') }}
)
select id, 'model_02514' as name from sources
