{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01510') }},
        {{ ref('model_02087') }},
        {{ ref('model_01519') }}
)
select id, 'model_02578' as name from sources
