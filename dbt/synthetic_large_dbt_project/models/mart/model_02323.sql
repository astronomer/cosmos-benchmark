{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01582') }},
        {{ ref('model_02113') }},
        {{ ref('model_02084') }}
)
select id, 'model_02323' as name from sources
