{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01132') }},
        {{ ref('model_01397') }}
)
select id, 'model_01986' as name from sources
