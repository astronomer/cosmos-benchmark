{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00980') }},
        {{ ref('model_01179') }}
)
select id, 'model_01660' as name from sources
