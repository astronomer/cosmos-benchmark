{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00282') }},
        {{ ref('model_00566') }},
        {{ ref('model_00523') }}
)
select id, 'model_01109' as name from sources
