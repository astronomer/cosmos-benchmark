{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01188') }},
        {{ ref('model_01237') }}
)
select id, 'model_01748' as name from sources
