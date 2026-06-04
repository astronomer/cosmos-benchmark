{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02197') }},
        {{ ref('model_02100') }},
        {{ ref('model_01822') }}
)
select id, 'model_02492' as name from sources
