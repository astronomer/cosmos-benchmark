{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00852') }},
        {{ ref('model_01136') }},
        {{ ref('model_01143') }}
)
select id, 'model_01872' as name from sources
