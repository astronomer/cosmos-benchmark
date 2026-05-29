{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01775') }},
        {{ ref('model_01734') }},
        {{ ref('model_01769') }}
)
select id, 'model_02370' as name from sources
