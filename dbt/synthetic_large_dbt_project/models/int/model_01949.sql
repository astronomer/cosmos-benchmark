{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01064') }},
        {{ ref('model_01264') }}
)
select id, 'model_01949' as name from sources
