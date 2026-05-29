{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01480') }},
        {{ ref('model_01192') }},
        {{ ref('model_01175') }}
)
select id, 'model_01510' as name from sources
