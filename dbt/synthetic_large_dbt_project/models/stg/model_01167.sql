{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00052') }},
        {{ ref('model_00429') }},
        {{ ref('model_00315') }}
)
select id, 'model_01167' as name from sources
