{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00445') }},
        {{ ref('model_00735') }}
)
select id, 'model_01226' as name from sources
