{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00757') }},
        {{ ref('model_01481') }},
        {{ ref('model_01185') }}
)
select id, 'model_01815' as name from sources
