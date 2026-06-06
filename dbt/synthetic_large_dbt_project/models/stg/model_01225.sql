{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00457') }},
        {{ ref('model_00200') }},
        {{ ref('model_00210') }}
)
select id, 'model_01225' as name from sources
