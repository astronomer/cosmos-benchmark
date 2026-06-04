{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00788') }},
        {{ ref('model_01047') }},
        {{ ref('model_00915') }}
)
select id, 'model_01915' as name from sources
