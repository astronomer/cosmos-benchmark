{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00368') }},
        {{ ref('model_00036') }},
        {{ ref('model_00095') }}
)
select id, 'model_01176' as name from sources
