{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01195') }},
        {{ ref('model_01417') }},
        {{ ref('model_01106') }}
)
select id, 'model_02235' as name from sources
