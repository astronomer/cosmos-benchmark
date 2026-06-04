{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01932') }},
        {{ ref('model_02196') }}
)
select id, 'model_02525' as name from sources
