{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01602') }},
        {{ ref('model_01863') }}
)
select id, 'model_02407' as name from sources
