{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00007') }},
        {{ ref('model_00591') }},
        {{ ref('model_00535') }}
)
select id, 'model_01003' as name from sources
