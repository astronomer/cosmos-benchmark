{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01210') }},
        {{ ref('model_01433') }}
)
select id, 'model_01562' as name from sources
