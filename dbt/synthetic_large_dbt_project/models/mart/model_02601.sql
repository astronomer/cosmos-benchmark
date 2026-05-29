{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01976') }},
        {{ ref('model_01972') }}
)
select id, 'model_02601' as name from sources
