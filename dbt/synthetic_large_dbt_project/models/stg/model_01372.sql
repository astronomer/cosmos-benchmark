{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00628') }},
        {{ ref('model_00706') }},
        {{ ref('model_00538') }}
)
select id, 'model_01372' as name from sources
