{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00135') }},
        {{ ref('model_00210') }},
        {{ ref('model_00741') }}
)
select id, 'model_01199' as name from sources
