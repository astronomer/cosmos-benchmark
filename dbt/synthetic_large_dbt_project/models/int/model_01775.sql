{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01415') }},
        {{ ref('model_01096') }},
        {{ ref('model_01357') }}
)
select id, 'model_01775' as name from sources
