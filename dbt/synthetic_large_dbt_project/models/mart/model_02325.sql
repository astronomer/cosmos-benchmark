{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01898') }},
        {{ ref('model_02065') }},
        {{ ref('model_02023') }}
)
select id, 'model_02325' as name from sources
