{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01618') }},
        {{ ref('model_02118') }}
)
select id, 'model_02769' as name from sources
