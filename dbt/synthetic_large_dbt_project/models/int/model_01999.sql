{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01490') }},
        {{ ref('model_01058') }}
)
select id, 'model_01999' as name from sources
