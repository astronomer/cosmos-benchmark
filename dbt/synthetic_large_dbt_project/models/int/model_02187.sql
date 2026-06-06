{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01185') }},
        {{ ref('model_01158') }}
)
select id, 'model_02187' as name from sources
