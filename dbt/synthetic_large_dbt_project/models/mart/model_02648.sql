{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02190') }},
        {{ ref('model_01719') }},
        {{ ref('model_02107') }}
)
select id, 'model_02648' as name from sources
