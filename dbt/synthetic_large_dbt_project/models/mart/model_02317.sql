{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01910') }},
        {{ ref('model_02063') }},
        {{ ref('model_01918') }}
)
select id, 'model_02317' as name from sources
