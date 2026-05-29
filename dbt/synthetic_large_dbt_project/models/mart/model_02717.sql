{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02023') }},
        {{ ref('model_01999') }}
)
select id, 'model_02717' as name from sources
