{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01683') }},
        {{ ref('model_01616') }}
)
select id, 'model_02843' as name from sources
