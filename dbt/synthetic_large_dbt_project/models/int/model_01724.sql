{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01396') }},
        {{ ref('model_01473') }}
)
select id, 'model_01724' as name from sources
