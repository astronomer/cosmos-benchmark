{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00242') }},
        {{ ref('model_00275') }}
)
select id, 'model_01037' as name from sources
