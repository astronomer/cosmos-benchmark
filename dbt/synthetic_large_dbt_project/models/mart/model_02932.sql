{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02161') }},
        {{ ref('model_01796') }},
        {{ ref('model_01799') }}
)
select id, 'model_02932' as name from sources
