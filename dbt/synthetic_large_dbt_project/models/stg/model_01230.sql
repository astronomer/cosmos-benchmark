{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00391') }},
        {{ ref('model_00415') }},
        {{ ref('model_00390') }}
)
select id, 'model_01230' as name from sources
