{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01229') }},
        {{ ref('model_01358') }},
        {{ ref('model_00910') }}
)
select id, 'model_02222' as name from sources
