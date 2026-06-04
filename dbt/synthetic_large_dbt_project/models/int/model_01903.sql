{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00844') }},
        {{ ref('model_01284') }}
)
select id, 'model_01903' as name from sources
