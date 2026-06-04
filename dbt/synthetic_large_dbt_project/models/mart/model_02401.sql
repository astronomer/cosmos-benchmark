{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01626') }},
        {{ ref('model_01884') }}
)
select id, 'model_02401' as name from sources
