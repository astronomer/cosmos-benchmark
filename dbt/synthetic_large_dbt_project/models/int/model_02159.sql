{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00835') }},
        {{ ref('model_00905') }},
        {{ ref('model_00757') }}
)
select id, 'model_02159' as name from sources
