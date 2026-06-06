{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00952') }},
        {{ ref('model_01000') }},
        {{ ref('model_01184') }}
)
select id, 'model_01712' as name from sources
