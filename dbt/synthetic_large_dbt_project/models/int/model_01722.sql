{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01489') }},
        {{ ref('model_01106') }}
)
select id, 'model_01722' as name from sources
