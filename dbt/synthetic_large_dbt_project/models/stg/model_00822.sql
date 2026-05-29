{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00669') }},
        {{ ref('model_00168') }}
)
select id, 'model_00822' as name from sources
