{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01878') }},
        {{ ref('model_01811') }},
        {{ ref('model_01798') }}
)
select id, 'model_02312' as name from sources
