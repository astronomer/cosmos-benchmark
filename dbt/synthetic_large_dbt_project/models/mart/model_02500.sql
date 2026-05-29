{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01562') }},
        {{ ref('model_02070') }},
        {{ ref('model_01560') }}
)
select id, 'model_02500' as name from sources
