{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00382') }},
        {{ ref('model_00718') }},
        {{ ref('model_00108') }}
)
select id, 'model_00915' as name from sources
