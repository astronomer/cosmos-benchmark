{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01654') }},
        {{ ref('model_01718') }},
        {{ ref('model_01814') }}
)
select id, 'model_02563' as name from sources
