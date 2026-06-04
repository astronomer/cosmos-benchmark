{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00738') }},
        {{ ref('model_00419') }},
        {{ ref('model_00109') }}
)
select id, 'model_00916' as name from sources
