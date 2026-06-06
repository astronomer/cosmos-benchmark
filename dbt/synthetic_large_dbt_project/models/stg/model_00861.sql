{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00728') }},
        {{ ref('model_00667') }},
        {{ ref('model_00305') }}
)
select id, 'model_00861' as name from sources
