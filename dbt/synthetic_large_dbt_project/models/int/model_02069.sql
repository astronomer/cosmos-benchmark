{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01046') }},
        {{ ref('model_01433') }}
)
select id, 'model_02069' as name from sources
