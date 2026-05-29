{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00623') }},
        {{ ref('model_00056') }},
        {{ ref('model_00316') }}
)
select id, 'model_00761' as name from sources
