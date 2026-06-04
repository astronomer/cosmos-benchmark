{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02068') }},
        {{ ref('model_01848') }}
)
select id, 'model_02614' as name from sources
