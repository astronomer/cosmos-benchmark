{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01534') }},
        {{ ref('model_01743') }},
        {{ ref('model_01665') }}
)
select id, 'model_02428' as name from sources
