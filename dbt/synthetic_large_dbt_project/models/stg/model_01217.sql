{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00472') }},
        {{ ref('model_00410') }},
        {{ ref('model_00604') }}
)
select id, 'model_01217' as name from sources
