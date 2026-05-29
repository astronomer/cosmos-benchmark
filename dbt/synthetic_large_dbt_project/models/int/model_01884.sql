{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01106') }},
        {{ ref('model_00856') }}
)
select id, 'model_01884' as name from sources
