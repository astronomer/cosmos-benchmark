{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02157') }},
        {{ ref('model_01526') }}
)
select id, 'model_02433' as name from sources
