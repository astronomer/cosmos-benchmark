{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02217') }},
        {{ ref('model_02157') }},
        {{ ref('model_02073') }}
)
select id, 'model_02472' as name from sources
