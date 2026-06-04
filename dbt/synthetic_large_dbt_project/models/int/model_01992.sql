{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01040') }},
        {{ ref('model_01366') }}
)
select id, 'model_01992' as name from sources
