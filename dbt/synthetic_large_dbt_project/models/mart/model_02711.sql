{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01904') }},
        {{ ref('model_01528') }}
)
select id, 'model_02711' as name from sources
