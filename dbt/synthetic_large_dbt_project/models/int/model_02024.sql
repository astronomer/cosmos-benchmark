{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01483') }},
        {{ ref('model_01164') }},
        {{ ref('model_01151') }}
)
select id, 'model_02024' as name from sources
