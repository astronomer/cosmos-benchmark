{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00638') }},
        {{ ref('model_00718') }},
        {{ ref('model_00604') }}
)
select id, 'model_01096' as name from sources
