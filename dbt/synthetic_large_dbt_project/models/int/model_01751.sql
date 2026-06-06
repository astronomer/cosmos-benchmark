{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01428') }},
        {{ ref('model_01303') }}
)
select id, 'model_01751' as name from sources
