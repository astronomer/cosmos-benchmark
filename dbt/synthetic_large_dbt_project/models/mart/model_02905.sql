{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02246') }},
        {{ ref('model_01506') }},
        {{ ref('model_02001') }}
)
select id, 'model_02905' as name from sources
