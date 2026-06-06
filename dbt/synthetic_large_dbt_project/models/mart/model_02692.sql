{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01678') }},
        {{ ref('model_01962') }}
)
select id, 'model_02692' as name from sources
