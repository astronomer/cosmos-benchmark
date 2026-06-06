{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01975') }},
        {{ ref('model_02171') }}
)
select id, 'model_02321' as name from sources
