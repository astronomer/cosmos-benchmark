{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01769') }},
        {{ ref('model_01649') }}
)
select id, 'model_02474' as name from sources
