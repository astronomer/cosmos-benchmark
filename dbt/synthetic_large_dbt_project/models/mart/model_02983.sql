{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01848') }},
        {{ ref('model_01864') }}
)
select id, 'model_02983' as name from sources
