{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01055') }},
        {{ ref('model_01335') }}
)
select id, 'model_01782' as name from sources
