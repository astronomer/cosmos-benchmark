{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01695') }},
        {{ ref('model_01933') }},
        {{ ref('model_01881') }}
)
select id, 'model_02655' as name from sources
