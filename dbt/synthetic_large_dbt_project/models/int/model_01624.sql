{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01364') }},
        {{ ref('model_01459') }}
)
select id, 'model_01624' as name from sources
