{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01649') }},
        {{ ref('model_02156') }},
        {{ ref('model_01540') }}
)
select id, 'model_02715' as name from sources
