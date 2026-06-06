{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02230') }},
        {{ ref('model_01950') }}
)
select id, 'model_02341' as name from sources
