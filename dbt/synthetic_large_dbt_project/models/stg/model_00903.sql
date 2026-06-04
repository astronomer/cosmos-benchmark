{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00346') }},
        {{ ref('model_00531') }},
        {{ ref('model_00535') }}
)
select id, 'model_00903' as name from sources
