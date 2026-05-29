{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01445') }},
        {{ ref('model_01307') }},
        {{ ref('model_01210') }}
)
select id, 'model_02039' as name from sources
