{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00390') }},
        {{ ref('model_00080') }},
        {{ ref('model_00057') }}
)
select id, 'model_01114' as name from sources
