{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01290') }},
        {{ ref('model_01450') }},
        {{ ref('model_01373') }}
)
select id, 'model_01816' as name from sources
