{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01695') }},
        {{ ref('model_01759') }},
        {{ ref('model_02207') }}
)
select id, 'model_02875' as name from sources
