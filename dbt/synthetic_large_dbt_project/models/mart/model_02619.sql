{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02228') }},
        {{ ref('model_01646') }}
)
select id, 'model_02619' as name from sources
