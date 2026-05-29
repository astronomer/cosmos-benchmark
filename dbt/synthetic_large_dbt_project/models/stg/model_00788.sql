{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00255') }},
        {{ ref('model_00096') }},
        {{ ref('model_00473') }}
)
select id, 'model_00788' as name from sources
