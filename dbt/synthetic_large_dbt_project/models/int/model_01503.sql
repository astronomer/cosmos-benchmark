{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01060') }},
        {{ ref('model_01383') }}
)
select id, 'model_01503' as name from sources
