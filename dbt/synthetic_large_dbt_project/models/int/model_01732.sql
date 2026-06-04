{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01176') }},
        {{ ref('model_01420') }},
        {{ ref('model_01045') }}
)
select id, 'model_01732' as name from sources
