{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01087') }},
        {{ ref('model_00882') }},
        {{ ref('model_01369') }}
)
select id, 'model_02190' as name from sources
