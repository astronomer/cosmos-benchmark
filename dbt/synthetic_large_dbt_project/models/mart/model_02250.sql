{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01503') }},
        {{ ref('model_01818') }},
        {{ ref('model_01780') }}
)
select id, 'model_02250' as name from sources
