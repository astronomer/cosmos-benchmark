{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00041') }},
        {{ ref('model_00374') }},
        {{ ref('model_00375') }}
)
select id, 'model_01323' as name from sources
