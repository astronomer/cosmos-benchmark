{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00153') }},
        {{ ref('model_00484') }},
        {{ ref('model_00009') }}
)
select id, 'model_01041' as name from sources
