{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01219') }},
        {{ ref('model_01032') }},
        {{ ref('model_00956') }}
)
select id, 'model_01672' as name from sources
