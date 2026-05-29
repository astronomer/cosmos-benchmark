{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01863') }},
        {{ ref('model_01517') }},
        {{ ref('model_02139') }}
)
select id, 'model_02942' as name from sources
