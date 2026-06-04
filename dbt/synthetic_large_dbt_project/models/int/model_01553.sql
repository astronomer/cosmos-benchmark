{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01499') }},
        {{ ref('model_01176') }}
)
select id, 'model_01553' as name from sources
