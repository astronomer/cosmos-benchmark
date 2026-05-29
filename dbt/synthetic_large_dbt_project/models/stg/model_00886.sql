{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00156') }},
        {{ ref('model_00210') }},
        {{ ref('model_00711') }}
)
select id, 'model_00886' as name from sources
