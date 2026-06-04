{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00225') }},
        {{ ref('model_00269') }}
)
select id, 'model_01067' as name from sources
