{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00046') }},
        {{ ref('model_00248') }},
        {{ ref('model_00718') }}
)
select id, 'model_01284' as name from sources
